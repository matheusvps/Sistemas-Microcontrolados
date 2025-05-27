#include "leds.h"

// Lab2
#include "gpio_config.h"
#include "systick.h"

/**
 * @brief Converte um ângulo em graus para o enum LEDS_Degrees.
 * @param angle O ângulo em graus (0 a 360).
 */
LEDS_Degrees leds_angle(uint16_t angle) {
    if (angle > 360) {
        angle %= 360;
    }
    if (angle >= 0 && angle < 45) {
        return LEDS_0;
    } else if (angle >= 45 && angle < 90) {
        return LEDS_45;
    } else if (angle >= 90 && angle < 135) {
        return LEDS_90;
    } else if (angle >= 135 && angle < 180) {
        return LEDS_135;
    } else if (angle >= 180 && angle < 225) {
        return LEDS_180;
    } else if (angle >= 225 && angle < 270) {
        return LEDS_225;
    } else if (angle >= 270 && angle < 315) {
        return LEDS_270;
    } else if (angle >= 315 && angle < 360) {
        return LEDS_315;
    } else {
        return LEDS_360;
    }
}

/**
 * @brief Determina a direção de rotação dos LEDs com base no ângulo.
 * 
 */
LEDS_Direction leds_direction(int8_t direction) {
    if (direction < 0) {
        return LEDS_COUNTERCLOCKWISE; // Direção anti-horária.
    } else {
        return LEDS_CLOCKWISE; // Direção horária.
    }
}
/**
 * @brief Inverte os bits de um byte.
 * @param b O byte a ser invertido.
 * @return O byte com os bits invertidos.
 */
uint8_t reverse_bits(uint8_t b) {
    return ((b & 0x80) >> 7) | ((b & 0x40) >> 5) | ((b & 0x20) >> 3) | ((b & 0x10) >> 1) |
           ((b & 0x08) << 1) | ((b & 0x04) << 3) | ((b & 0x02) << 5) | ((b & 0x01) << 7);
}

/**
 * @brief Acende o LED correspondente ao ângulo especificado.
 * @param angle O ângulo do LED a ser aceso.
 * @param direction A direção de rotação do LED (horário ou anti-horário).
 */
void leds_on(uint16_t angle, int8_t direction) {
    LEDS_Degrees leds_degrees = leds_angle(angle);
    switch (leds_direction(direction)) {
        case LEDS_CLOCKWISE:
            switch (leds_degrees) {
                case LEDS_0:
                    PortQ_Output(LEDS_0 & 0x0F);
                    PortA_Output((LEDS_0 & ~(1 << 3)) | (((LEDS_0 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_45:
                    PortQ_Output(LEDS_45 & 0x0F);
                    PortA_Output((LEDS_45 & ~(1 << 3)) | (((LEDS_45 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_90:
                    PortQ_Output(LEDS_90 & 0x0F);
                    PortA_Output((LEDS_90 & ~(1 << 3)) | (((LEDS_90 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_135:
                    PortQ_Output(LEDS_135 & 0x0F);
                    PortA_Output((LEDS_135 & ~(1 << 3)) | (((LEDS_135 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_180:
                    PortQ_Output(LEDS_180 & 0x0F);
                    PortA_Output((LEDS_180 & ~(1 << 3)) | (((LEDS_180 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_225:
                    PortQ_Output(LEDS_225 & 0x0F);
                    PortA_Output((LEDS_225 & ~(1 << 3)) | (((LEDS_225 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_270:
                    PortQ_Output(LEDS_270 & 0x0F);
                    PortA_Output((LEDS_270 & ~(1 << 3)) | (((LEDS_270 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_315:
                    PortQ_Output(LEDS_315 & 0x0F);
                    PortA_Output((LEDS_315 & ~(1 << 3)) | (((LEDS_315 >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_360:
                    PortQ_Output(LEDS_360 & 0x0F);
                    PortA_Output((LEDS_360 & ~(1 << 3)) | (((LEDS_360 >> 2) & 1) << 3) & 0xF8);
                    break;
                default:
                    break;
            }
            break;

        case LEDS_COUNTERCLOCKWISE:
            switch (leds_degrees) {
                case LEDS_0:
                    PortQ_Output(reverse_bits(LEDS_0) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_0) & ~(1 << 3)) | (((reverse_bits(LEDS_0) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_45:
                    PortQ_Output(reverse_bits(LEDS_45) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_45) & ~(1 << 3)) | (((reverse_bits(LEDS_45) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_90:
                    PortQ_Output(reverse_bits(LEDS_90) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_90) & ~(1 << 3)) | (((reverse_bits(LEDS_90) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_135:
                    PortQ_Output(reverse_bits(LEDS_135) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_135) & ~(1 << 3)) | (((reverse_bits(LEDS_135) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_180:
                    PortQ_Output(reverse_bits(LEDS_180) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_180) & ~(1 << 3)) | (((reverse_bits(LEDS_180) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_225:
                    PortQ_Output(reverse_bits(LEDS_225) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_225) & ~(1 << 3)) | (((reverse_bits(LEDS_225) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_270:
                    PortQ_Output(reverse_bits(LEDS_270) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_270) & ~(1 << 3)) | (((reverse_bits(LEDS_270) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_315:
                    PortQ_Output(reverse_bits(LEDS_315) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_315) & ~(1 << 3)) | (((reverse_bits(LEDS_315) >> 2) & 1) << 3) & 0xF8);
                    break;
                case LEDS_360:
                    PortQ_Output(reverse_bits(LEDS_360) & 0x0F);
                    PortA_Output((reverse_bits(LEDS_360) & ~(1 << 3)) | (((reverse_bits(LEDS_360) >> 2) & 1) << 3) & 0xF8);
                    break;
                default:
                    break;
            }
            break;
    }
    PortB_Output(0x00); // Desliga displays de 7 segmentos.
    PortP_Output(0xFF); // Liga os LEDs.
}

/**
 * @brief Desliga todos os LEDS.
 */
void leds_off(void) {
    PortP_Output(0x00); // Desiga os LEDs.
    PortQ_Output(0x00);
    PortA_Output(0x00);
}
