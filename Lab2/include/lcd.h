// lcd.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef LCD_H
    #define LCD_H

    // C
    #include <stdint.h>
    #include <string.h>

    typedef enum {
        LCD_DISPLAY_ON_NO_CURSOR       = 0x0C,
        LCD_DISPLAY_OFF                = 0x0A,
        LCD_CLEAR_WITH_HOME_CURSOR     = 0x01,
        LCD_DISPLAY_AND_CURSOR_ON      = 0x0E,
        LCD_CURSOR_OFF                 = 0x0C,
        LCD_CURSOR_BLINK               = 0x0D,
        LCD_CURSOR_MOVE_RIGHT          = 0x14,
        LCD_CURSOR_MOVE_LEFT           = 0x10,
        LCD_CURSOR_HOME                = 0x02,
        LCD_CURSOR_ALTERNATING         = 0x0F,
        LCD_CURSOR_DIRECTION_LEFT      = 0x04,
        LCD_CURSOR_DIRECTION_RIGHT     = 0x06,
        LCD_MESSAGE_DIRECTION_LEFT     = 0x07,
        LCD_MESSAGE_DIRECTION_RIGHT    = 0x05,
        LCD_CHAR_ENTRY_DIRECTION_LEFT  = 0x18,
        LCD_CHAR_ENTRY_DIRECTION_RIGHT = 0x1C,
        LCD_FIRST_LINE_FIRST_POSITION  = 0x80,
        LCD_SECOND_LINE_FIRST_POSITION = 0xC0,
        LCD_ENABLE_WRITE_COMMAND       = 0x04,
        LCD_ENABLE_WRITE_DATA          = 0x05,
        LCD_DISABLE_WRITE              = 0x00,
        LCD_2_LINES_8_BITS_MODE        = 0x38
    } LCD_Command; // Comandos do LCD.

    /**
     * @brief Inicializa o LCD.
     */
    void LCD_Init(void);

    /**
     * @brief Envia um comando para o LCD.
     * @param cmd O comando a ser enviado.
     */
    void lcd_command(LCD_Command cmd);

    /**
     * @brief Envia dados para o LCD.
     * @param data Os dados a serem enviados.
     */
    void lcd_data(uint8_t data);

    /**
     * @brief Imprime uma string no LCD.
     * @param str A string a ser impressa.
     */
    void lcd_print(const char *str);

    /**
     * @brief Mostra uma string em uma linha específica do LCD.
     * @param line A linha onde a string será mostrada (0 ou 1).
     * @param str A string a ser mostrada.
     */
    void lcd_display_line(uint8_t line, const char *str);

#endif // LCD_H
