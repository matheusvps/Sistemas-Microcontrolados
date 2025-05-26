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
extern int16_t angle_decoder(uint8_t key_pressed);
extern void LCD_Display_Number(int32_t number);
extern uint32_t TecladoM_Poll(void);

// Variável global para armazenar o ângulo atual
int32_t angulo_atual = 0;

int main(void) {
    uint32_t tecla;
    int16_t incremento_angulo;
    
    // Inicializações
    PLL_Init();
    SysTick_Init();
    GPIO_Init();
    Timer2_Init();
    LCD_Init();
    Motor_Init();

    // Mensagem inicial
    lcd_display_line(0, "Angulo Atual:");
    LCD_Display_Number(angulo_atual);

    while (1) {
        // Lê o teclado matricial
        tecla = TecladoM_Poll();
        
        if(tecla != 0) {
            // Decodifica o incremento do ângulo baseado na tecla pressionada
            incremento_angulo = angle_decoder(tecla);
            
            // Atualiza o ângulo atual
            angulo_atual += incremento_angulo;
            
            // Garante que o ângulo fique entre 0 e 360 graus
            if(angulo_atual >= 360) {
                angulo_atual = angulo_atual % 360;
            }
            
            // Atualiza o display com o novo ângulo
            LCD_Display_Number(angulo_atual);
            
            // Atualiza a posição do motor
            Motor_Move(angulo_atual);
            
            // Pequeno delay para debounce
            SysTick_Wait1ms(100);
        }
    }
}
