// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Matheus Passos, Lucas Yukio, João Castilho

// C
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

// Lab3
#include "adc.h"
#include "gpio_config.h"
#include "pwm.h"
#include "servomotor.h"
#include "systick.h"
#include "uart.h"

void PLL_Init(void);
void Timer_Init(void);

typedef enum {
    CONTROL_NONE,    // Nenhum controle selecionado
    CONTROL_POT,     // Controlado via potenciômetro
    CONTROL_TERMINAL // Controlado via terminal UART
} control_mode_t; // Enum para os modos de controle

const int angle_table[9] = {-90, -60, -45, -30, 0, 30, 45, 60, 90}; // Tabela de ângulos correspondentes aos números 1-9

/**
 * @brief Função principal do programa.
 */
int main(void) {
    PLL_Init();
    SysTick_Init();
    GPIO_Init();
    Timer1A_Init();
    adc_init();
    uart0_init();
    pwm_init();
    servomotor_init();

    control_mode_t mode = CONTROL_NONE; // Inicializa o modo de controle como nenhum
    int current_angle = 0; // Ângulo atual do servomotor
    uint32_t last_pot_adc = 0xFFFFFFFF; // Última leitura do ADC para o potenciômetro
    uint32_t last_print = 0; // Tempo da última impressão no terminal
    char uart_str[64]; // Buffer para mensagens UART

    uart0_write("Selecione o modo de controle:\r\n");
    uart0_write("Digite 'p' para potenciometro ou 't' para terminal:\r\n");

    while (true) {
        uart0_check_timeout();

        if (uart0_get_message(uart_str, sizeof(uart_str))) {
            if (uart_str[0] == 'p' || uart_str[0] == 'P') {
                mode = CONTROL_POT;
                uart0_write(" Modo potenciometro selecionado.\r\n");
            } else if (uart_str[0] == 't' || uart_str[0] == 'T') {
                mode = CONTROL_TERMINAL;
                uart0_write(" Modo terminal selecionado.\r\n");
                uart0_write("Digite um numero de 1 a 9 para a posicao do servo:\r\n");
                uart0_write("1:-90 2:-60 3:-45 4:-30 5:0 6:+30 7:+45 8:+60 9:+90\r\n");
            } else if (mode == CONTROL_TERMINAL && uart_str[0] >= '1' && uart_str[0] <= '9') {
                int idx = uart_str[0] - '1'; // Converte de '1'-'9' para 0-8
                servomotor_set_angle(angle_table[idx]);
                char msg[40]; // Buffer para mensagem
                snprintf(msg, sizeof(msg), " Servo em %d graus\r\n", servomotor_get_angle());
                uart0_write(msg);
            }
        }

        if (mode == CONTROL_POT) {
            static uint32_t last_adc_check = 0; // Última verificação do ADC
            if (millis - last_adc_check >= 100) { // a cada 100ms
                last_adc_check = millis;
                uint32_t adc_val = adc_read(); // Lê o valor do ADC
                servomotor_set_angle_by_adc(adc_val);
                if (millis - last_print >= 1000) {
                    last_print = millis;
                    char msg[40]; // Buffer para mensagem
                    snprintf(msg, sizeof(msg), "Servo em %d graus (pot)\r\n", servomotor_get_angle());
                    uart0_write(msg);
                }
            }
        }

        SysTick_Wait1ms(10);
    }
}
