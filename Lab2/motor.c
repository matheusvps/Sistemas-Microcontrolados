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

/**
 * @brief Gira o motor de passo.
 * @param graus O número de graus que o motor deve girar.
 * @param direcao A direção de rotação (1 para horário, -1 para anti-horário).
 * @param modo O modo de operação (1 para passo completo, 2 para meio passo).
 */
void giraMotor(int graus, int direcao, int modo) {
    int passos = (PASSOS_POR_VOLTA * modo * graus) / 360; // Calcula o número de passos necessários para girar a quantidade de graus desejada.

    int i; // Contador de passos.
    int j; // Contador de meio passo.

    if(modo == 1){
        for (i = 0; i < passos; i++) {
            for (j = 0; j < 4; j++) {
                if (direcao == -1)
                    j = abs(j - 3); // Se a direção é anti-horária, inverte j.
                
                // Atribuir os sinais aos pinos aqui utilizando [j][0], [j][1], [j][2], [j][3] e a tabela passoCompleto.

                
                SysTick_Wait1ms(5); // Tempo de espera necessário após a energização da bobina.
            }
        }
    }
    else if (modo == 2) {
        for (i = 0; i < passos; i++) {
            for (j = 0; j < 8; j++) {
                if (direcao == -1)
                    j = abs(j - 7); // Se a direção é anti-horária, inverte j.
                
                // Atribuir os sinais aos pinos aqui utilizando [j][0], [j][1], [j][2], [j][3], [j][4], [j][5], [j][6], [j][7] e a tabela meiopasso.

                SysTick_Wait1ms(5); // Tempo de espera necessário após a energização da bobina.
            }
        }

    }
}
