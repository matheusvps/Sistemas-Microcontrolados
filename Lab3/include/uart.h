// uart.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef UART_H
    #define UART_H

    /**
     * @brief Inicializa o UART0 para comunicação serial.
     */
    void uart0_init(void);

    /**
     * @brief Verifica se houve timeout na recepção de uma mensagem pelo UART0.
     */
    void uart0_check_timeout(void);

    /**
     * @brief Verifica se uma mensagem completa foi recebida pelo UART0.
     * @param dest Ponteiro para o buffer onde a mensagem será armazenada.
     * @param maxlen Tamanho máximo do buffer de destino.
     * @return true se uma mensagem completa foi recebida, false caso contrário.
     */
    bool uart0_get_message(char *dest, size_t maxlen);

    /**
     * @brief Envia uma string pelo UART0.
     * @param str Ponteiro para a string a ser enviada.
     */
    void uart0_write(const char* str);

#endif // UART_H
