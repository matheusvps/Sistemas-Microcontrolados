// systick.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "systick.h"

// C
#include <stdint.h>

// Lab3
#include "tm4c1294ncpdt.h"

volatile uint32_t millis = 0; // Variável global para o tempo em milissegundos.

/**
 * @brief Inicializa o contador millis.
 */
void Timer1A_Init(void) {
    SYSCTL_RCGCTIMER_R |= SYSCTL_RCGCTIMER_R1;
    while ((SYSCTL_PRTIMER_R & SYSCTL_PRTIMER_R1) == 0);
    TIMER1_CTL_R = 0;
    TIMER1_CFG_R = 0x0;
    TIMER1_TAMR_R = 0x2; // modo periódico
    TIMER1_TAILR_R = 80000 - 1; // 1ms para 80MHz
    TIMER1_ICR_R = 0x1;
    TIMER1_IMR_R = 0x1;
    NVIC_EN0_R |= 1 << (INT_TIMER1A - 16);
    TIMER1_CTL_R |= 0x1;
}

/**
 * @brief Interrupção do millis.
 */
void Timer1A_Handler(void) {
    TIMER1_ICR_R = 0x1;
    millis++;
}
