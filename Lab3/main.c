// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Matheus Passos, Lucas Yukio, João Castilho

// C
#include <stdint.h>

// Lab3
#include "gpio_config.h"
#include "interface.h"
#include "systick.h"
#include "uart.h"

void PLL_Init(void);
void Timer_Init(void);

int main(void) {
    PLL_Init();
    SysTick_Init();
    GPIO_Init();
    UART0_Initi();
    Timer2_Init();

    while (1) {
        processar_interface();
    }
}
