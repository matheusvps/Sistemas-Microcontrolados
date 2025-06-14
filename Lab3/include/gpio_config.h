// gpio_config.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef GPIO_CONFIG_H
    #define GPIO_CONFIG_H

    #include <stdint.h>

    typedef enum {
        GPIO_PORTD = 0x0008, // Bit 3.
        GPIO_PORTL = 0x0400, // Bit 10.
    } GPIO_Port; // Enum for GPIO ports.

    /**
     * @brief Inicializa as portas do GPIO.
     */
    void GPIO_Init(void);

    /**
     * @brief Saída da porta D (PD4-7).
     * @param valor Valor a ser escrito na porta D.
     */
    void PortD_Output(uint32_t valor);

    /**
     * @brief Saída da porta L (PL4-7).
     * @param valor Valor a ser escrito na porta L.
     */
    void PortL_Output(uint32_t valor);

    /**
     * @brief Inicializa o Timer 2 para uso com interrupção periódica.
     */
    void Timer2_Init(void);

    /**
     * @brief Inicia a contagem do Timer 2.
     */
    void Timer2_Start(void);

    /**
     * @brief Para a contagem do Timer 2.
     */
    void Timer2_Stop(void);

    /**
     * @brief Handler da interrupção do Timer 2A.
     */
    void Timer2A_Handler(void);

#endif // GPIO_H