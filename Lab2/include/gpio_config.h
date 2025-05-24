// gpio.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef GPIO_CONFIG_H
    #define GPIO_CONFIG_H

    #include <stdint.h>

    typedef enum {
        GPIO_PORTA = 0x0001, // Bit 0.
        GPIO_PORTB = 0x0002, // Bit 1.
        GPIO_PORTC = 0x0004, // Bit 2 (não utilizável - JTAG).
        GPIO_PORTD = 0x0008, // Bit 3.
        GPIO_PORTE = 0x0010, // Bit 4.
        GPIO_PORTF = 0x0020, // Bit 5.
        GPIO_PORTG = 0x0040, // Bit 6.
        GPIO_PORTH = 0x0080, // Bit 7.
        GPIO_PORTJ = 0x0100, // Bit 8.
        GPIO_PORTK = 0x0200, // Bit 9.
        GPIO_PORTL = 0x0400, // Bit 10.
        GPIO_PORTM = 0x0800, // Bit 11.
        GPIO_PORTN = 0x1000, // Bit 12.
        GPIO_PORTP = 0x4000, // Bit 13.
        GPIO_PORTQ = 0x8000  // Bit 14.
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
     * @brief Saída da porta E (PE0-3).
     * @param valor Valor a ser escrito na porta E.
     */
    void PortE_Output(uint32_t valor);

    /**
     * @brief Entrada da porta E (PE4-7).
     * @return Valor lido da porta E.
     */
    uint32_t PortE_Input(void);

    /**
     * @brief Saída da porta F (PF0-7).
     * @param valor Valor a ser escrito na porta F.
     */
    void PortF_Output(uint32_t valor);

    /**
     * @brief Saída da porta H (PH0-7).
     * @param valor Valor a ser escrito na porta H.
     */
    void PortH_Output(uint32_t valor);

    /**
     * @brief Entrada da porta J (PJ0-7).
     * @return Valor lido da porta J.
     */
    uint32_t PortJ_Input(void);

    /**
     * @brief Saída da porta K (PK0-7).
     * @param valor Valor a ser escrito na porta K.
     */
    void PortK_Output(uint32_t valor);

    /**
     * @brief Saída da porta L (PL4-7).
     * @param valor Valor a ser escrito na porta L.
     */
    void PortL_Output(uint32_t valor);

    /**
     * @brief Entrada da porta L (PL0-3).
     * @return Valor lido da porta L.
     */
    uint32_t PortL_Input(void);

    /**
     * @brief Saída da porta M (PM0-3).
     * @param valor Valor a ser escrito na porta M.
     */
    void PortM_Output(uint32_t valor);

    /**
     * @brief Entrada da porta M (PM4-7).
     * @return Valor lido da porta M.
     */
    uint32_t PortM_Input(void);

    /**
     * @brief Saída da porta N (PN0-7).
     * @param valor Valor a ser escrito na porta N.
     */
    void PortN_Output(uint32_t valor);

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