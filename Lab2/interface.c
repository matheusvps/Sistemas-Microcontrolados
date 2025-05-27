#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include "lcd.h"
#include "motor.h"
#include "matricial.h"
#include "systick.h"

// Estados da interface
typedef enum {
    ESTADO_ANGULO,
    ESTADO_DIRECAO,
    ESTADO_VELOCIDADE,
    ESTADO_GIRANDO,
    ESTADO_FIM
} InterfaceEstado;

// Variáveis globais
static InterfaceEstado estado_atual = ESTADO_ANGULO;
static int angulo = 0;
static int direcao = 1;  // 1 para horário, -1 para anti-horário
static int velocidade = 1;  // 1 para passo completo, 2 para meio passo

/**
 * @brief Processa a entrada do ângulo
 * @return 1 se o ângulo foi lido com sucesso, 0 caso contrário
 */
static int processar_angulo(void) {
    char str[17];
    int valor = TecladoM_Read3Digits();
    
    if (valor == 0xFFFFFFFF) {
        lcd_display_line(0, "Angulo invalido!");
        lcd_display_line(1, "Tente novamente");
        SysTick_Wait1ms(1000);
        return 0;
    }
    
    if (valor > 360 || valor < 0) {
        lcd_display_line(0, "Angulo deve ser");
        lcd_display_line(1, "entre 0 e 360!");
        SysTick_Wait1ms(1000);
        return 0;
    }
    
    if (valor % 15 != 0) {
        lcd_display_line(0, "Angulo deve ser");
        lcd_display_line(1, "multiplo de 15!");
        SysTick_Wait1ms(1000);
        return 0;
    }
    
    // Se chegou aqui, o valor é válido
    angulo = valor;
    snprintf(str, sizeof(str), "Angulo: %03d", angulo);
    lcd_display_line(0, str);
    lcd_display_line(1, "Pressione tecla");
    return 1;
}

/**
 * @brief Processa a seleção de direção
 * @return 1 se a direção foi selecionada, 0 caso contrário
 */
static int processar_direcao(void) {
    lcd_display_line(0, "Direcao:");
    lcd_display_line(1, "1-Hor 2-AntiHor");
    
    uint8_t tecla = TecladoM_Poll();
    
    if (tecla == '1') {
        direcao = 1;
        return 1;
    } else if (tecla == '2') {
        direcao = -1;
        return 1;
    }
    
    return 0;
}

/**
 * @brief Processa a seleção de velocidade
 * @return 1 se a velocidade foi selecionada, 0 caso contrário
 */
static int processar_velocidade(void) {
    lcd_display_line(0, "Velocidade:");
    lcd_display_line(1, "1-Full 2-Half");
    
    uint8_t tecla = TecladoM_Poll();
    
    if (tecla == '1') {
        velocidade = 1;
        return 1;
    } else if (tecla == '2') {
        velocidade = 2;
        return 1;
    }
    
    return 0;
}

/**
 * @brief Atualiza o display durante o giro do motor
 * @param angulo_atual Ângulo atual do motor
 */
static void atualizar_display_giro(int angulo_atual) {
    char str[17];
    snprintf(str, sizeof(str), "Dir:%s Vel:%s", 
             direcao == 1 ? "Hor" : "Anti",
             velocidade == 1 ? "Full" : "Half");
    lcd_display_line(0, str);
    
    snprintf(str, sizeof(str), "Pos: %d graus", angulo_atual);
    lcd_display_line(1, str);
}

/**
 * @brief Processa o estado atual da interface
 * @return 1 se deve continuar processando, 0 se deve resetar
 */
int processar_interface(void) {
    // Verifica reset
    if (TecladoM_CheckAsterisk()) {
        estado_atual = ESTADO_ANGULO;
        lcd_command(LCD_CLEAR_WITH_HOME_CURSOR);
        return 1;
    }
    
    switch (estado_atual) {
        case ESTADO_ANGULO:
            lcd_display_line(0, "Digite o angulo:");
            lcd_display_line(1, "(000 a 360)");
            if (processar_angulo()) {
                estado_atual = ESTADO_DIRECAO;
            }
            break;
            
        case ESTADO_DIRECAO:
            if (processar_direcao()) {
                estado_atual = ESTADO_VELOCIDADE;
            }
            break;
            
        case ESTADO_VELOCIDADE:
            if (processar_velocidade()) {
                estado_atual = ESTADO_GIRANDO;
            }
            break;
            
        case ESTADO_GIRANDO:
            // Inicia o giro do motor
            giraMotor(angulo, direcao, velocidade);
            estado_atual = ESTADO_FIM;
            break;
            
        case ESTADO_FIM:
            lcd_display_line(0, "FIM");
            lcd_display_line(1, "* para reiniciar");
            break;
    }
    
    return 1;
} 