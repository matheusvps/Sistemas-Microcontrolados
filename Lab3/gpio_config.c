// gpio_config.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron

#include "gpio_config.h"

// C
#include <stdint.h>

// Lab2
#include "systick.h"
#include "tm4c1294ncpdt.h"

/**
 * @brief Inicializa as portas do GPIO.
 */
void GPIO_Init(void) {
    // 1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO.
    SYSCTL_RCGCGPIO_R = (GPIO_PORTD | GPIO_PORTL);

    // 1b. Verificar no PRGPIO se a porta está pronta para uso.
    while ((SYSCTL_PRGPIO_R & (GPIO_PORTD | GPIO_PORTL)) != (GPIO_PORTD | GPIO_PORTL)) {};

    // 2. Limpar o AMSEL para desabilitar a analógica.
    GPIO_PORTD_AHB_AMSEL_R &= ~0xF0; // PD4-7 (PD0-3 SPI).
    GPIO_PORTL_AMSEL_R = 0x00; // PL0-7.

    // 3. Limpar PCTL para selecionar o GPIO.
    GPIO_PORTD_AHB_PCTL_R &= ~0xF0; // PD4-7 (PD0-3 SPI).
    GPIO_PORTL_PCTL_R = 0x00; // PL0-7.

    // 4. DIR para 0 se for entrada, 1 se for saída.
    GPIO_PORTD_AHB_DIR_R = (GPIO_PORTD_AHB_DIR_R & ~0xF0) | 0xF0; // PD4-7 saída (PD0-3 SPI).
    GPIO_PORTL_DIR_R = 0xF0; // PL0-3 entrada e PL4-7 saída.

    // 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa.
    GPIO_PORTD_AHB_AFSEL_R &= ~0xF0; // PD4-7 (PD0-3 SPI).
    GPIO_PORTL_AFSEL_R = 0x00; // PL0-7.


    // 6. Setar os bits de DEN para habilitar I/O digital.
    GPIO_PORTD_AHB_DEN_R |= 0xF0; // PD4-7 (PD0-3 SPI).
    GPIO_PORTL_DEN_R = 0xFF; // PL0-7.

    // 7. Habilitar o resistor de pull-up interno, setar PUR para 1.
    GPIO_PORTL_PUR_R = 0x0F; // PL0-3.
}

/**
 * @brief Saída da porta D (PD0-3).
 * @param valor Valor a ser escrito na porta D.
 */
void PortD_Output(uint32_t valor) {
    GPIO_PORTD_AHB_DATA_R = (GPIO_PORTD_AHB_DATA_R & 0x0F) | (valor & 0xF0); // Saídas PD4-7 (PD0-3 SPI).
}

/**
 * @brief Saída da porta L (PL4-7).
 * @param valor Valor a ser escrito na porta L.
 */
void PortL_Output(uint32_t valor) {
    GPIO_PORTL_DATA_R = (GPIO_PORTL_DATA_R & 0x0F) | (valor & 0xF0); // Saídas PL4-7
}

/**
 * @brief Entrada da porta L (PL0-3).
 * @return Valor lido da porta L.
 */
uint32_t PortL_Input(void) {
    return GPIO_PORTL_DATA_R & 0x0F; // Entradas PL0-3.
}

/**
 * @brief Inicializa o Timer 2 para uso com interrupção periódica.
 */
void Timer2_Init(void) {
    SYSCTL_RCGCTIMER_R = 4; // Seta o bit do timer 2 para uso.

    while (SYSCTL_PRTIMER_R != 4) {}; // Testa até o bit do timer 2 ser setado.

    TIMER2_CTL_R = 0; // Desabilita o timer 2 para configuração.

    TIMER2_CFG_R = 0x00; // Seta para modo de 32 bits.

    // Seta para modo periódico
    TIMER2_TAMR_R = 2;

    // Valor de contagem de 95ms para timer e setando prescale para 0 (ciclo de 95ms apagado e 5ms aceso).
    TIMER2_TAILR_R = 7599999;
    TIMER2_TAPR_R = 0;

    TIMER2_ICR_R = 1; // Limpa a flag de interrupção.

    TIMER2_IMR_R = 1; // Seta a interrupção no timer.

    // Seta a prioridade e habilita a interrupção.
    NVIC_PRI5_R = 4 << 29;
    NVIC_EN0_R = 1 << 23;
}

/**
 * @brief Inicia a contagem do Timer 2.
 */
void Timer2_Start(void) {
    TIMER2_ICR_R = 1; // Limpa a flag de interrupção.

    TIMER2_CTL_R = 1; // Liga o timer.
}

/**
 * @brief Para a contagem do Timer 2.
 */
void Timer2_Stop(void) {
    TIMER2_ICR_R = 1; // Limpa a flag de interrupção.

    TIMER2_CTL_R = 0; // Desliga o timer.
}

/** 
 * @brief Handler da interrupção do Timer 2A, chamado quando o timer 2 zera.
 */
void Timer2A_Handler(void) {
    TIMER2_ICR_R = 1; // Limpa a flag de interrupção.

    // Pisca o LED 1 da placa.
    PortN_Output(0x1);
    SysTick_Wait1ms(5);
    PortN_Output(0x0);
}
