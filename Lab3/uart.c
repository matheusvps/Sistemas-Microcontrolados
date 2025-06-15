// uart.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "uart.h"

// C
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <time.h>

// Lab3
#include "systick.h"
#include "tm4c1294ncpdt.h"

// Frequência do clock do sistema (Hz)
#define SYSCLK 80000000UL

// Tamanho do buffer para mensagens recebidas
#define UART0_BUFFER_SIZE 64

// Tempo limite para receber uma mensagem completa (em milissegundos)
#define UART0_TIMEOUT_MS 1000

typedef enum {
    UART0_BAUD_RATE_9600   = 9600,
    UART0_BAUD_RATE_19200  = 19200,
    UART0_BAUD_RATE_33600  = 33600,
    UART0_BAUD_RATE_57600  = 57600,
    UART0_BAUD_RATE_115200 = 115200,
} uart0_baud_rate_t; // Tipos de taxa de baud

typedef enum {
    UART0_PARITY_NONE, // Sem paridade
    UART0_PARITY_ODD,  // Paridade ímpar
    UART0_PARITY_EVEN, // Paridade par
    UART0_PARITY_MARK, // Paridade de marca (bit de paridade sempre 1)
    UART0_PARITY_SPACE // Paridade de espaço (bit de paridade sempre 0)
} uart0_parity_t; // Tipos de paridade

typedef enum {
    UART0_STOPBITS_1, // 1 bit de stop
    UART0_STOPBITS_2  // 2 bits de stop
} uart0_stopbits_t; // Tipos de stop bits

volatile char uart0_buffer[UART0_BUFFER_SIZE]; // Buffer para armazenar mensagens recebidas

volatile uint8_t uart0_buf_idx = 0; // Índice do buffer para a próxima posição a ser escrita

volatile bool uart0_msg_ready = false; // Flag para indicar se uma mensagem completa foi recebida

volatile clock_t uart0_last_char_time = 0; // Último tempo em que um caractere foi recebido

extern volatile clock_t millis; // Variável global para o tempo em milissegundos

// Configurações padrão do UART0
static const uart0_baud_rate_t UART0_BAUD_RATE = UART0_BAUD_RATE_115200; // Taxa de baud padrão
static const uart0_parity_t UART0_PARITY = UART0_PARITY_EVEN; // Paridade padrão
static const uart0_stopbits_t UART0_STOPBITS = UART0_STOPBITS_1; // Stop bits padrão

/**
 * @brief Inicializa o UART0 para comunicação serial.
 */
void uart0_init(void) {
    // 1. Habilitar o clock do UART0 e esperar estar pronto
    SYSCTL_RCGCUART_R |= SYSCTL_RCGCUART_R0;
    while ((SYSCTL_PRUART_R & SYSCTL_PRUART_R0) == 0);

    // 2. Garantir que a UART esteja desabilitada antes de configurar
    UART0_CTL_R &= ~UART_CTL_UARTEN;

    // 3. Escrever o baud-rate nos registradores UARTIBRD e UARTFBRD
    double brd = (double)SYSCLK / (16 * UART0_BAUD_RATE);
    UART0_IBRD_R = (uint32_t)brd;
    UART0_FBRD_R = (uint32_t)((brd - (uint32_t)brd) * 64 + 0.5);

    // 4. Configurar UARTLCRH conforme macros de paridade e stop bits
    uint32_t lcrh = UART_LCRH_WLEN_8;
    // Paridade
    switch (UART0_PARITY) {
        case UART0_PARITY_ODD:
            lcrh |= UART_LCRH_PEN;
            break;
        case UART0_PARITY_EVEN:
            lcrh |= UART_LCRH_PEN | UART_LCRH_EPS;
            break;
        case UART0_PARITY_MARK:
            lcrh |= UART_LCRH_PEN | UART_LCRH_SPS;
            break;
        case UART0_PARITY_SPACE:
            lcrh |= UART_LCRH_PEN | UART_LCRH_EPS | UART_LCRH_SPS;
            break;
        case UART0_PARITY_NONE:
        default:
            break;
    }
    // Stop bits
    if (UART0_STOPBITS == UART0_STOPBITS_2) {
        lcrh |= UART_LCRH_STP2;
    }
    UART0_LCRH_R = lcrh;

    // 5. Garantir que a fonte de clock seja o clock do sistema (opcional, padrão já é 0)
    UART0_CC_R = 0;

    // 6. Habilitar RXE, TXE e UARTEN no UARTCTL
    UART0_CTL_R |= (UART_CTL_UARTEN | UART_CTL_TXE | UART_CTL_RXE);

    // 7. Habilitar o clock do GPIOA e esperar estar pronto
    SYSCTL_RCGCGPIO_R |= SYSCTL_RCGCGPIO_R0;
    while ((SYSCTL_PRGPIO_R & SYSCTL_PRGPIO_R0) == 0);

    // 8. Desabilitar funcionalidade analógica nos pinos PA0 e PA1
    GPIO_PORTA_AHB_AMSEL_R &= ~0x03;

    // 9. Configurar função alternativa dos pinos PA0 (U0RX) e PA1 (U0TX)
    GPIO_PORTA_AHB_PCTL_R = (GPIO_PORTA_AHB_PCTL_R & ~0xFF) | 0x11;

    // 10. Habilitar função alternativa nos pinos PA0 e PA1
    GPIO_PORTA_AHB_AFSEL_R |= 0x03;

    // 11. Configurar os pinos PA0 e PA1 como digitais
    GPIO_PORTA_AHB_DEN_R |= 0x03;

    // 12. Habilitar interrupções de recebimento no UART0
    UART0_IM_R |= UART_IM_RXIM;

    // 13. Habilitar a interrupção da UART0 no NVIC
    NVIC_EN0_R |= 1 << (INT_UART0 - 16);

    // 14. Definir prioridade da interrupção
    NVIC_PRI1_R = (NVIC_PRI1_R & ~(0xFF << 5)) | (2 << 5); // Bits 13:5 para UART0
}

/**
 * @brief Handler da interrupção do UART0.
 */
void UART0_Handler(void) {
    if (UART0_MIS_R & UART_MIS_RXMIS) {
        char c = UART0_DR_R & 0xFF; // Lê o caractere recebido
        uart0_last_char_time = millis;

        if (!uart0_msg_ready) {
            if (c == '\r') {
                uart0_buffer[uart0_buf_idx] = '\0';
                uart0_msg_ready = true;
                uart0_buf_idx = 0;
            } else if (c == '\n') {
                // Descarta o caractere de nova linha
            } else if (uart0_buf_idx < UART0_BUFFER_SIZE - 1) {
                uart0_buffer[uart0_buf_idx++] = c;
            } else {
                uart0_buffer[uart0_buf_idx] = '\0';
                uart0_msg_ready = true;
                uart0_buf_idx = 0;
            }
        }
        UART0_ICR_R = UART_ICR_RXIC;
    }
}

/**
 * @brief Verifica se houve timeout na recepção de uma mensagem pelo UART0.
 */
void uart0_check_timeout(void) {
    if (!uart0_msg_ready && uart0_buf_idx > 0) {
        if ((millis - uart0_last_char_time) > UART0_TIMEOUT_MS) {
            uart0_buffer[uart0_buf_idx] = '\0';
            uart0_msg_ready = true;
            uart0_buf_idx = 0;
        }
    }
}

/**
 * @brief Verifica se uma mensagem completa foi recebida pelo UART0.
 * @param dest Ponteiro para o buffer onde a mensagem será armazenada.
 * @param maxlen Tamanho máximo do buffer de destino.
 * @return true se uma mensagem completa foi recebida, false caso contrário.
 */
bool uart0_get_message(char *dest, size_t maxlen) {
    if (uart0_msg_ready) {
        strncpy(dest, (const char*)uart0_buffer, maxlen);
        dest[maxlen - 1] = '\0';
        uart0_clear_rx_buffer();
        return true;
    }
    return false;
}

/**
 * @brief Envia uma string pelo UART0.
 * @param str Ponteiro para a string a ser enviada.
 */
void uart0_write(const char* str) {
    while (*str) {
        // Espera até que o transmissor esteja pronto
        while (UART0_FR_R & UART_FR_TXFF);
        
        // Envia o caractere
        UART0_DR_R = *str++;
    }
}

/**
 * @brief Limpa o buffer do UART0.
 */
void uart0_clear_rx_buffer(void) {
    uart0_buf_idx = 0;
    uart0_msg_ready = false;
    memset((void*)uart0_buffer, 0, UART0_BUFFER_SIZE);
}
