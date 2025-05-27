// angle.c
// Desenvolvido para a placa EK-TM4C1294XL, para servir funções auxiliares no tratamento de dados
// Matheus Passos, Lucas Yukio, João Pedro Castilho

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