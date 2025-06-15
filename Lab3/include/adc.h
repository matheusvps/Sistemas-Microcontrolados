// adc.h
// Desenvolvido para a placa EK-TM4C1294XL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef ADC_H
    #define ADC_H

    // C
    #include <stdint.h>
    
    /**
     * @brief Inicializa o ADC (Conversor Analógico-Digital).
     */
    void adc_init(void);

    /**
     * @brief Lê o valor do ADC.
     * @return Valor lido do ADC.
     */
    uint32_t adc_read(void);

#endif // ADC_H