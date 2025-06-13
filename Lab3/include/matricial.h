#ifndef MATRICIAL_H
#define MATRICIAL_H

#include <stdint.h>

// Lê uma tecla do teclado matricial
// Retorna: valor ASCII da tecla ou 0x10 se nenhuma tecla pressionada
uint8_t TecladoM_Poll(void);

#endif // MATRICIAL_H 