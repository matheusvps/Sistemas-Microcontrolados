// pwm.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "pwm.h"

// C
#include <stdint.h>

// Lab3
#include "systick.h"
#include "tm4c1294ncpdt.h"

// Parâmetros do PWM
// Frequência do sistema: 80MHz
#define PWM_PERIOD_TICKS 1600000

// Período mínimo do PWM: 0,5 ms
#define PWM_MIN_HIGH_TICKS 40000

// Período máximo do PWM: 2,5 ms
#define PWM_MAX_HIGH_TICKS 200000

volatile uint32_t pwm_high_ticks = PWM_MIN_HIGH_TICKS; // Duty cycle (tempo em alta)
volatile uint8_t pwm_pin_state = 0; // 0 = LOW, 1 = HIGH

/**
 * @brief Inicializa o PWM no pino PL4 usando o Timer 0A.
 */
void pwm_init(void) {
    // 1. Habilitar clock do GPIO L e do Timer 0
    SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R10; // GPIO L
    SYSCTL_RCGCTIMER_R |= SYSCTL_RCGCTIMER_R0; // Timer 0
    while ((SYSCTL_PRGPIO_R & SYSCTL_PRGPIO_R10) == 0);

    // 2. Configurar PL4 como saída digital
    GPIO_PORTL_DIR_R |= (1 << 4);
    GPIO_PORTL_DEN_R |= (1 << 4);

    // 3. Configurar Timer 0A como timer de intervalo
    TIMER0_CTL_R &= ~TIMER_CTL_TAEN; // Desabilita TimerA
    TIMER0_CFG_R = 0x0; // 32 bits
    TIMER0_TAMR_R = TIMER_TAMR_TAMR_1_SHOT; // Modo one-shot (será rearmado na ISR)
    TIMER0_TAILR_R = pwm_high_ticks; // Começa com tempo em alta
    TIMER0_ICR_R = TIMER_ICR_TATOCINT; // Limpa flag de interrupção
    TIMER0_IMR_R |= TIMER_IMR_TATOIM; // Habilita interrupção

    // 4. Habilitar interrupção no NVIC
    NVIC_EN0_R |= 1 << (INT_TIMER0A - 16);

    // 5. Inicializa pino em HIGH e inicia timer
    pwm_pin_state = 1;
    GPIO_PORTL_DATA_R |= (1 << 4);
    TIMER0_CTL_R |= TIMER_CTL_TAEN;
}

/**
 * @brief Configura o duty cycle do PWM.
 */
void pwm_set_high_ticks(uint32_t high_ticks) {
    if (high_ticks < PWM_MIN_HIGH_TICKS) high_ticks = PWM_MIN_HIGH_TICKS;
    if (high_ticks > PWM_PERIOD_TICKS) high_ticks = PWM_PERIOD_TICKS;
    pwm_high_ticks = high_ticks;
}

/**
 * @brief Converte um ângulo em ticks para o PWM.
 * @param angle Ângulo em graus (-90 a +90).
 * @return Ticks correspondentes ao ângulo.
 */
uint32_t pwm_angle_to_ticks(int angle) {
    return PWM_MIN_HIGH_TICKS + ((angle + 90) * (PWM_MAX_HIGH_TICKS - PWM_MIN_HIGH_TICKS)) / 180;
}

// Handler da interrupção do Timer0A
void Timer0A_Handler(void) {
    TIMER0_ICR_R = TIMER_ICR_TATOCINT; // Limpa flag

    if (pwm_pin_state) {
        // Estava em HIGH, vai para LOW
        GPIO_PORTL_DATA_R &= ~(1 << 4);
        pwm_pin_state = 0;
        TIMER0_TAILR_R = PWM_PERIOD_TICKS - pwm_high_ticks; // Tempo em baixa
    } else {
        // Estava em LOW, vai para HIGH
        GPIO_PORTL_DATA_R |= (1 << 4);
        pwm_pin_state = 1;
        TIMER0_TAILR_R = pwm_high_ticks; // Tempo em alta
    }
    TIMER0_CTL_R |= TIMER_CTL_TAEN; // Rearma o timer (one-shot)
}
