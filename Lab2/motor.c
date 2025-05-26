// motor.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#define PASSOS_POR_VOLTA 512 // Número de passos por volta do motor de passo.

#include "motor.h"

// C
#include <stdint.h>
#include <stdlib.h>

// Lab2
#include "gpio_config.h"
#include "systick.h"

// Variável global para armazenar a posição atual do motor em graus
static int32_t posicao_atual = 0;

const int passoCompleto[4][4] = {
    {1, 0, 0, 0},
    {0, 1, 0, 0},
    {0, 0, 1, 0},
    {0, 0, 0, 1}
};

const int meioPasso[8][4] = {
    {1, 0, 0, 0},
    {1, 1, 0, 0},
    {0, 1, 0, 0},
    {0, 1, 1, 0},
    {0, 0, 1, 0},
    {0, 0, 1, 1},
    {0, 0, 0, 1},
    {1, 0, 0, 1}
};

void Motor_Init(void) {
    // Inicializa os pinos do motor como saída
    // Assumindo que os pinos do motor estão conectados ao PORTE
    GPIO_PORTE_DIR_R |= 0x0F;  // Configura PE0-PE3 como saída
    GPIO_PORTE_DEN_R |= 0x0F;  // Habilita função digital para PE0-PE3
    
    // Inicializa com todos os pinos em baixo
    GPIO_PORTE_DATA_R &= ~0x0F;
}

void Motor_Move(int32_t angulo_destino) {
    int32_t diferenca;
    int direcao;
    
    // Calcula a diferença entre a posição atual e a desejada
    diferenca = angulo_destino - posicao_atual;
    
    // Determina a direção de rotação
    if(diferenca > 0) {
        direcao = 1;  // Horário
    } else {
        direcao = -1; // Anti-horário
        diferenca = abs(diferenca);
    }
    
    // Gira o motor usando passo completo
    giraMotor(diferenca, direcao, 1);
    
    // Atualiza a posição atual
    posicao_atual = angulo_destino;
}

/**
 * @brief Gira o motor de passo.
 * @param graus O número de graus que o motor deve girar.
 * @param direcao A direção de rotação (1 para horário, -1 para anti-horário).
 * @param modo O modo de operação (1 para passo completo, 2 para meio passo).
 */
void giraMotor(int graus, int direcao, int modo) {
    int passos = (PASSOS_POR_VOLTA * modo * graus) / 360;
    int i, j;
    uint8_t pino_valor;

    if(modo == 1) {
        for (i = 0; i < passos; i++) {
            for (j = 0; j < 4; j++) {
                int idx = (direcao == 1) ? j : (3 - j);
                
                // Configura os pinos do motor
                pino_valor = 0;
                pino_valor |= passoCompleto[idx][0] << 0;  // PE0
                pino_valor |= passoCompleto[idx][1] << 1;  // PE1
                pino_valor |= passoCompleto[idx][2] << 2;  // PE2
                pino_valor |= passoCompleto[idx][3] << 3;  // PE3
                
                // Atualiza os pinos
                GPIO_PORTE_DATA_R = (GPIO_PORTE_DATA_R & ~0x0F) | pino_valor;
                
                SysTick_Wait1ms(5);
            }
        }
    }
    else if (modo == 2) {
        for (i = 0; i < passos; i++) {
            for (j = 0; j < 8; j++) {
                int idx = (direcao == 1) ? j : (7 - j);
                
                // Configura os pinos do motor
                pino_valor = 0;
                pino_valor |= meioPasso[idx][0] << 0;  // PE0
                pino_valor |= meioPasso[idx][1] << 1;  // PE1
                pino_valor |= meioPasso[idx][2] << 2;  // PE2
                pino_valor |= meioPasso[idx][3] << 3;  // PE3
                
                // Atualiza os pinos
                GPIO_PORTE_DATA_R = (GPIO_PORTE_DATA_R & ~0x0F) | pino_valor;
                
                SysTick_Wait1ms(5);
            }
        }
    }
}
