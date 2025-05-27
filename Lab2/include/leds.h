#ifndef LEDS_H
    #define LEDS_H

    #include <stdint.h>

    typedef enum {
        LEDS_COUNTERCLOCKWISE,
        LEDS_CLOCKWISE
    } LEDS_Direction; // Representa a direção de rotação dos LEDS.

    typedef enum {
        LEDS_0   = 0x00,
        LEDS_45  = 0x01,
        LEDS_90  = 0x03,
        LEDS_135 = 0x07,
        LEDS_180 = 0x0F,
        LEDS_225 = 0x1F,
        LEDS_270 = 0x3F,
        LEDS_315 = 0x7F,
        LEDS_360 = 0xFF
    } LEDS_Degrees; // Representa os ângulos dos LEDS em graus e seus bits.

    LEDS_Direction leds_direction(int8_t direction);

    LEDS_Degrees leds_angle(uint16_t angle);

    void leds_on(uint16_t angle, int8_t direction);
    void leds_off(void);

#endif // LEDS_H
