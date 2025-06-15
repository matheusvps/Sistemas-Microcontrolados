// adc.c
// Desenvolvido para a placa EK-TM4C1294XL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "adc.h"

// C
#include <stdint.h>

// Lab3
#include "tm4c1294ncpdt.h"

// Taxa de amostragem (ADC_PC)
#define ADC_PC_SR_1M 0x3   // 1 Msps

// Selecionar trigger de software no SS3 (ADC_EMUX)
#define ADC_EMUX_EM3 0xF000 // Bits 15:12 correspondem ao SS3

/**
 * @brief Inicializa o ADC (Conversor Analógico-Digital) no canal PE4 (AIN9).
 */
void adc_init(void) {
    // 1. Habilitar o clock no módulo GPIOE e esperar estar pronto
    SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R4;
    while ((SYSCTL_PRGPIO_R & SYSCTL_PRGPIO_R4) == 0);

    // 2. Habilitar a funcionalidade analógica do pino PE4
    GPIO_PORTE_AHB_AMSEL_R |= (1 << 4);

    // 3. Configurar PE4 como entrada
    GPIO_PORTE_AHB_DIR_R &= ~(1 << 4);

    // 4. Habilitar função alternativa em PE4
    GPIO_PORTE_AHB_AFSEL_R |= (1 << 4);

    // 5. Desabilitar função digital em PE4
    GPIO_PORTE_AHB_DEN_R &= ~(1 << 4);

    // 6. Habilitar o clock do ADC0 e esperar estar pronto
    SYSCTL_RCGCADC_R |= SYSCTL_RCGCADC_R0;
    while ((SYSCTL_PRADC_R & SYSCTL_PRADC_R0) == 0);

    // 7. Escolher a máxima taxa de amostragem (1Msps)
    ADC0_PC_R = ADC_PC_SR_1M;

    // 8. Configurar prioridade dos sequenciadores (SS3 com menor prioridade)
    ADC0_SSPRI_R = 0x0123;

    // 9. Desabilitar o sequenciador SS3 para configurar
    ADC0_ACTSS_R &= ~ADC_ACTSS_ASEN3;

    // 10. Configurar o tipo de gatilho para SW no SS3
    ADC0_EMUX_R &= ~ADC_EMUX_EM3;

    // 11. Selecionar o canal AIN9 (PE4) no SS3
    ADC0_SSMUX3_R = 9;

    // 12. Configurar os bits de controle: IE0 e END0
    ADC0_SSCTL3_R = ADC_SSCTL3_IE0 | ADC_SSCTL3_END0;

    // 13. Habilitar o sequenciador SS3
    ADC0_ACTSS_R |= ADC_ACTSS_ASEN3;
}

/**
 * @brief Lê o valor do ADC no canal PE4 (AIN9).
 * @return Valor lido do ADC.
 */
uint32_t adc_read(void) {
    // 1. Iniciar o gatilho de SW no SS3
    ADC0_PSSI_R = ADC_PSSI_SS3;

    // 2. Polling até a conversão terminar
    while ((ADC0_RIS_R & ADC_RIS_INR3) == 0);

    // 3. Ler o resultado da conversão
    uint32_t value = ADC0_SSFIFO3_R; // Retorna o valor lido do FIFO do SS3

    // 4. Realizar o ACK para limpar a flag
    ADC0_ISC_R = ADC_ISC_IN3;

    // 5. Retornar o valor lido
    return value;
}
