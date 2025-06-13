#include "interface.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "lcd.h"
#include "leds.h"
#include "motor.h"
#include "matricial.h"
#include "systick.h"
#include "gpio_config.h"

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
 * @brief Aguarda o release (flanco de subida) de qualquer tecla
 */
static void aguardar_release(void) {
    while (TecladoM_Poll() != 0x10) {
        // espera até soltar
    }
}

/**
 * @brief Processa a entrada do ângulo
 * @return 1 se o ângulo foi lido com sucesso, 0 caso contrário
 */
static int processar_angulo(void) {
    static char buffer[4] = ""; // Para até 3 dígitos + null
    static int pos = 0;
    static uint8_t tecla_anterior = 0x10;
    static char ultimo_buffer[4] = "";
    char str[17];
    uint8_t tecla = TecladoM_Poll();    

    // Só processa no flanco de descida
    if (tecla == tecla_anterior) {
        return 0;
    }
    tecla_anterior = tecla;
    if (tecla == 0x10) {
        return 0;
    }

    int atualizou = 0;
    if (tecla >= '0' && tecla <= '9' && pos < 3) {
        buffer[pos++] = tecla;
        buffer[pos] = '\0';
        atualizou = 1;
    }
    else if (tecla == '*') { // Apaga último dígito
        if (pos > 0) {
            buffer[--pos] = '\0';
            atualizou = 1;
        }
    }
    else if (tecla == '#') { // Confirma
        if (pos == 0) {
            lcd_display_line(0, "Digite o angulo:");
            snprintf(str, sizeof(str), "(000 a 360) %s", buffer);
            lcd_display_line(1, str);
            // aguarda release para não voltar imediatamente
            aguardar_release();
            tecla_anterior = 0x10;
            return 0;
        }
        int valor = atoi(buffer);
        if (valor < 0 || valor > 360) {
            lcd_display_line(0, "Angulo deve ser");
            lcd_display_line(1, "entre 0 e 360!");
            SysTick_Wait1ms(1000);
            pos = 0;
            buffer[0] = '\0';
            // debounce
            aguardar_release();
            tecla_anterior = 0x10;
            return 0;
        }
        if (valor % 15 != 0) {
            lcd_display_line(0, "Angulo deve ser");
            lcd_display_line(1, "multiplo de 15!");
            SysTick_Wait1ms(1000);
            pos = 0;
            buffer[0] = '\0';
            // debounce
            aguardar_release();
            tecla_anterior = 0x10;
            return 0;
        }
        angulo = valor;
        pos = 0;
        buffer[0] = '\0';
        snprintf(str, sizeof(str), "Angulo: %03d", angulo);
        lcd_display_line(0, str);
        lcd_display_line(1, "Pressione tecla");
        // aguarda release para próximo estado
        aguardar_release();
        tecla_anterior = 0x10;
        return 1;
    }

    // Atualiza o display sempre que o buffer mudar
    if (atualizou || strcmp(buffer, ultimo_buffer) != 0) {
        lcd_display_line(0, "Digite o angulo:");
        snprintf(str, sizeof(str), "(000 a 360) %s", buffer);
        lcd_display_line(1, str);
        strncpy(ultimo_buffer, buffer, sizeof(ultimo_buffer));
    }
    return 0;
}

/**
 * @brief Processa a seleção de direção
 * @return 1 se a direção foi selecionada, 0 caso contrário
 */
static int processar_direcao(void) {
    lcd_display_line(0, "Direcao:");
    lcd_display_line(1, "1-Hor 2-AntiHor");

    uint8_t tecla = TecladoM_Poll();
    if (tecla == '1' || tecla == '2') {

        direcao = (tecla == '1') ? 1 : -1;
        // debounce
        aguardar_release();
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
    lcd_display_line(1, "1-Comple 2-Meio");

    uint8_t tecla = TecladoM_Poll();
    if (tecla == '1' || tecla == '2') {
        velocidade = (tecla == '1') ? 1 : 2;
        // debounce
        aguardar_release();
        return 1;
    }
    return 0;
}

/**
 * @brief Processa o estado atual da interface
 * @return 1 se deve continuar processando, 0 se deve resetar
 */
int processar_interface(void) {
    switch (estado_atual) {
        case ESTADO_ANGULO:
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
            // Inicia o giro do motor (atualiza display via callback)
            Timer2_Start();
            giraMotor(angulo, direcao, velocidade);
            Timer2_Stop();
            estado_atual = ESTADO_FIM;
            break;

        case ESTADO_FIM:
            lcd_display_line(0, "FIM");
            lcd_display_line(1, "* para reiniciar");
            // aguarda e reinicia se pressionar '*'
            if (TecladoM_Poll() == '*') {
                aguardar_release();
                estado_atual = ESTADO_ANGULO;
            }
            break;
    }
    return 1;
}
