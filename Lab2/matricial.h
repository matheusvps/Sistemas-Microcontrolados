#ifndef MATRICIAL_H
#define MATRICIAL_H

#include <stdint.h>

// Inicializa o teclado matricial
void TecladoM_Init(void);

// Lê uma tecla do teclado matricial
// Retorna: valor ASCII da tecla ou 0x10 se nenhuma tecla pressionada
uint8_t TecladoM_Poll(void);

// Lê três dígitos do teclado matricial
// Retorna: número formado pelos três dígitos ou 0xFFFFFFFF se inválido
uint32_t TecladoM_Read3Digits(void);

// Verifica se o botão '*' foi pressionado
// Retorna: 1 se pressionado, 0 caso contrário
uint8_t TecladoM_CheckAsterisk(void);

#endif // MATRICIAL_H 