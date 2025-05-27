#include "matricial.h"

#include <stdint.h>

#include "gpio_config.h"
#include "systick.h"

uint8_t TecladoM_Poll(void) {
    // Máscaras das colunas (PORTM): C1=M4(0x10), C2=M5(0x20), C3=M6(0x40), C4=M7(0x80)
    const uint8_t col_mask[4] = {0x10, 0x20, 0x40, 0x80};
    // Mapeamento das teclas: [linha][coluna] (linhas invertidas)
    const char keymap[4][4] = {
        {'D', 'C', 'B', 'A'},
        {'#', '9', '6', '3'},
        {'0', '8', '5', '2'},
        {'*', '7', '4', '1'}
    };

    for (int col = 0; col < 4; col++) {
        // Ativa apenas a coluna atual (nível baixo), demais em alta impedância
        PortM_Output(~col_mask[col] & 0xF0); // Coluna atual em 0, demais em 1 (alta impedância)
        for (volatile int d = 0; d < 100; d++); // Pequeno delay para estabilizar

        uint8_t linhas = PortL_Input() & 0x0F; // Lê as linhas (L1-L4)
        for (int lin = 0; lin < 4; lin++) {
            if (!(linhas & (1 << lin))) { // Se o bit está zerado, tecla pressionada
                return keymap[lin][col];
            }
        }
    }
    return 0x10; // Nenhuma tecla pressionada
}
