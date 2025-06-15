// servomotor.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef SERVOMOTOR_H
    #define SERVOMOTOR_H

    // C
    #include <stdint.h>

    /**
     * @brief Inicializa o servomotor.
     */
    void servomotor_init(void);

    /**
     * @brief Define o ângulo do servomotor.
     * @param angle Ângulo desejado em graus, entre -90 e +90.
     */
    void servomotor_set_angle(int angle);

    /**
     * @brief Define o ângulo do servomotor com base no valor do ADC.
     * @param adc_val Valor lido do ADC (0-4095).
     */
    void servomotor_set_angle_by_adc(uint32_t adc_val);

    /**
     * @brief Obtém o ângulo atual do servomotor.
     */
    int servomotor_get_angle(void);

#endif
