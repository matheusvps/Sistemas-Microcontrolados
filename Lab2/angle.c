// angle.c
// Desenvolvido para a placa EK-TM4C1294XL, para servir funções auxiliares no tratamento de dados
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include <stdint.h>

#define char_0 0x30
#define char_1 0x31
#define char_2 0x32
#define char_3 0x33
#define char_4 0x34
#define char_5 0x35
#define char_6 0x36
#define char_7 0x37
#define char_8 0x38
#define char_9 0x39
#define char_space 0x20

extern uint32_t LCD_Display_Character(uint32_t param);

//angle_decoder(uint8_t param)
//Recebe como parametro qual botão foi pressionado no teclado matricial
//Converte esse botão em um angulo que será somado ao angulo na memória
int16_t angle_decoder (uint8_t key_pressed){
    switch (key_pressed){
    case 0x31:
        return 15;
    case 0x32:
        return 30;
    case 0x33:
        return 45;
    case 0x34:
        return 60;
    case 0x35:
        return 90;
    case 0x36:
        return 180;
    case 0x37:
        return 15;
    case 0x38:
        return 30;
    case 0x39:
        return 45;
    case 0x41:
        return 60;
    case 0x42:
        return 90;
    case 0x43:
        return 180;
    default:
         return 0;
    }
}

//map_number(int32_t number)
//Recebe como parametro o numero que será transformado para usar no display
int32_t map_number(int32_t number){
    switch (number)
    {
    case 0:
        return char_0;
    case 1:
        return char_1;
    case 2:
        return char_2;
    case 3:
        return char_3;
    case 4:
        return char_4;
    case 5:
        return char_5;
    case 6:
        return char_6;
    case 7:
        return char_7;
    case 8:
        return char_8;
    case 9:
        return char_9;
    default:
        return char_space;
    }
}


//LCD_Display_Number(int32_t param)
//Recebe como parametro qual numero precisa ser separado 
//Converte esse angulo em até 3 digitos separados e printa eles nos displays
void LCD_Display_Number (int32_t number){
    int32_t centena, dezena, unidade;
    
    // Garante que o número está entre 0 e 999
    if(number < 0) number = 0;
    if(number > 999) number = 999;
    
    // Separa os dígitos
    centena = number / 100;
    dezena = (number % 100) / 10;
    unidade = number % 10;
    
    // Mostra os dígitos no display
    if(centena > 0) {
        LCD_Display_Character(map_number(centena));
        LCD_Display_Character(map_number(dezena));
        LCD_Display_Character(map_number(unidade));
    } else if(dezena > 0) {
        LCD_Display_Character(char_space);
        LCD_Display_Character(map_number(dezena));
        LCD_Display_Character(map_number(unidade));
    } else {
        LCD_Display_Character(char_space);
        LCD_Display_Character(char_space);
        LCD_Display_Character(map_number(unidade));
    }
    
    return;
}

//LCD_Display_Number(int16_t n1, int16_t n2, int16_t n3)
//Recebe como parametro os 3 numeros a serem mostrados no display
//Printa esses numeros no LCD chamando a função assembly