// lcd.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "lcd.h"

// C
#include <stdint.h>
#include <string.h>

// Lab2
#include "gpio_config.h"
#include "systick.h"

/**
 * @brief Inicializa o LCD.
 */
void LCD_Init(void) {
    lcd_command(LCD_2_LINES_8_BITS_MODE);
    lcd_command(LCD_CURSOR_DIRECTION_RIGHT);
    lcd_command(LCD_DISPLAY_AND_CURSOR_ON);
    lcd_command(LCD_CLEAR_WITH_HOME_CURSOR);
    SysTick_Wait1us(1600);
    lcd_command(LCD_CURSOR_OFF);
}

/**
 * @brief Envia um comando para o LCD.
 * @param cmd O comando a ser enviado.
 */
void lcd_command(LCD_Command cmd) {
    PortK_Output(cmd);
    PortM_Output(LCD_ENABLE_WRITE_COMMAND);
    SysTick_Wait1us(500);
    PortM_Output(LCD_DISABLE_WRITE);
    SysTick_Wait1us(500);
}

/**
 * @brief Envia dados para o LCD.
 * @param data Os dados a serem enviados.
 */
void lcd_data(uint8_t data) {
    PortK_Output(data);
    PortM_Output(LCD_ENABLE_WRITE_DATA);
    SysTick_Wait1us(500);
    PortM_Output(LCD_DISABLE_WRITE);
    SysTick_Wait1us(500);
}

/**
 * @brief Imprime uma string no LCD.
 * @param str A string a ser impressa.
 */
void lcd_print(const char *str) {
    while (*str) {
        lcd_data(*str++);
    }
}

/**
 * @brief Mostra uma string em uma linha específica do LCD.
 * @param line A linha onde a string será mostrada (0 ou 1).
 * @param str A string a ser mostrada.
 */
void lcd_display_line(uint8_t line, const char *str) {
    static char last_str0[17] = {'\0'};
    static char last_str1[17] = {'\0'};

    if (line == 0) {
        if (strcmp(last_str0, str) == 0) {
            return; // Não atualiza se a string for a mesma
        }
        strncpy(last_str0, str, 16);
    } else {
        if (strcmp(last_str1, str) == 0) {
            return; // Não atualiza se a string for a mesma
        }
        strncpy(last_str1, str, 16);
    }

    lcd_command(LCD_DISPLAY_AND_CURSOR_ON);
    lcd_command(LCD_CLEAR_WITH_HOME_CURSOR);

    if (last_str0[0] != '\0') {
        lcd_command(LCD_FIRST_LINE_FIRST_POSITION);
        lcd_print(last_str0);
    }
    if (last_str1[0] != '\0') {
        lcd_command(LCD_SECOND_LINE_FIRST_POSITION);
        lcd_print(last_str1);
    }

    lcd_command(LCD_CURSOR_OFF);
}
