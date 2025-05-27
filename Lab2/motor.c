// motor.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "motor.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gpio_config.h"
#include "lcd.h"
#include "leds.h"
#include "systick.h"

#define PASSOS_POR_VOLTA 512 // Número de passos por volta do motor de passo.

// Sequências de excitação para passo completo e meio passo
static const int passoCompleto[4][4] = {
    {1, 0, 0, 0},
    {0, 1, 0, 0},
    {0, 0, 1, 0},
    {0, 0, 0, 1}
};
static const int meioPasso[8][4] = {
    {1, 0, 0, 0},
    {1, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 1, 0},
    {0, 0, 1, 0},
    {0, 0, 1, 1},
    {0, 0, 0, 1},
    {1, 0, 0, 1}
};

/**
 * @brief Atualiza o display durante o giro do motor
 * @param angulo_atual Ângulo atual do motor
 * @param direcao Direção de rotação (1 para horário, -1 para anti-horário)
 * @param velocidade Velocidade de rotação (1 para passo completo, 2 para meio passo)
 */
void atualizar_display_giro(int angulo_atual, int direcao, int velocidade) {
    char str[17];
    snprintf(str, sizeof(str), "Dir:%s Vel:%s", 
             direcao == 1 ? "Hor" : "Anti",
             velocidade == 1 ? "Comp" : "Meio");
    lcd_display_line(0, str);
    snprintf(str, sizeof(str), "Posicao: %d\xDF", angulo_atual);
    lcd_display_line(1, str);
    leds_on(angulo_atual, direcao);
}

/**
 * @brief Gira o motor de passo.
 * @param graus O número de graus que o motor deve girar.
 * @param direcao 1 = horário, -1 = anti-horário.
 * @param modo 1 = passo completo, 2 = meio passo.
 */
void giraMotor(int graus, int direcao, int modo) {
    // Total de passos para girar 'graus'
    int total_passos = (PASSOS_POR_VOLTA * modo * graus) / 360;
    // Sub-etapas por passo (4=completo, 8=meio)
    int etapas = (modo == 1) ? 4 : 8;
    // Incremento de ângulo por passo (graus)
    float delta_angulo = 360.0f / (PASSOS_POR_VOLTA * modo);
    // Ângulo acumulado
    float angulo_atual = 0.0f;
    // Próximo ângulo no qual vamos atualizar o display
    float proximo_marcador = 15.0f;

    for (int i = 0; i < total_passos; i++) {
        for (int step = 0; step < etapas; step++) {
            int idx = (direcao == 1)
                      ? step
                      : (etapas - step) % etapas;
            const int *seq = (modo == 1) ? passoCompleto[idx] : meioPasso[idx];
            uint8_t sinais = (seq[0] << 0) |
                             (seq[1] << 1) |
                             (seq[2] << 2) |
                             (seq[3] << 3);
            PortH_Output(sinais);
            SysTick_Wait1ms(5);
        }

        // Acumula o ângulo
        angulo_atual += delta_angulo;

        // Se passou do próximo múltiplo de 15°, atualiza display
        if (angulo_atual >= proximo_marcador) {
            atualizar_display_giro((int)angulo_atual, direcao, modo);
            proximo_marcador += 15.0f;
        }
    }

    // Garante atualização final no ângulo exato solicitado
    if (angulo_atual < graus) {
        angulo_atual = graus;
        atualizar_display_giro((int)angulo_atual, direcao, modo);
    }
}

