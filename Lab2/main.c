// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

// C
#include <stdint.h>

// Lab2
#include "gpio_config.h"
#include "lcd.h"
#include "motor.h"
#include "systick.h"

void PLL_Init(void);
void Timer_Init(void);
void Pisca_leds(void);
uint32_t TecladoM_Poll(void);

int main(void) {
    PLL_Init();
    SysTick_Init();
    GPIO_Init();
    Timer2_Init();
    LCD_Init();

    lcd_display_line(0, "Teste do LCD");
    lcd_display_line(1, "123456789abcd");

    while (1) {
        TecladoM_Poll();
    //Se a USR_SW2 estiver pressionada
        if (PortJ_Input() == 0x1)
            PortN_Output(0x1);
    //Se a USR_SW1 estiver pressionada
        else if (PortJ_Input() == 0x2)
            PortN_Output(0x2);
    //Se ambas estiverem pressionadas
        else if (PortJ_Input() == 0x0)
            Pisca_leds();
    //Se nenhuma estiver pressionada
        else if (PortJ_Input() == 0x3)
            PortN_Output(0x0);
    }
}

void Pisca_leds(void) {
    PortN_Output(0x2);
    SysTick_Wait1ms(250);
    PortN_Output(0x1);
    SysTick_Wait1ms(250);
}
