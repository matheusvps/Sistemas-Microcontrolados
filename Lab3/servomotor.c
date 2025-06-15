// servomotor.c
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#include "servomotor.h"

// C
#include <stdint.h>

// Lab3
#include "adc.h"
#include "pwm.h"
#include "systick.h"
#include "tm4c1294ncpdt.h"

static int current_angle = 0; // Ângulo atual do servomotor, em graus

/**
 * @brief Inicializa o servomotor.
 */
void servomotor_init(void) {
    pwm_init();
    servomotor_set_angle(0);
}

/**
 * @brief Define o ângulo do servomotor.
 * @param angle Ângulo desejado em graus, entre -90 e +90.
 */
void servomotor_set_angle(int angle) {
    if (angle < -90) angle = -90;
    if (angle > 90) angle = 90;
    current_angle = angle;
    pwm_set_high_ticks(pwm_angle_to_ticks(angle));
}

/**
 * @brief Define o ângulo do servomotor com base no valor do ADC.
 * @param adc_val Valor lido do ADC (0-4095).
 */
void servomotor_set_angle_by_adc(uint32_t adc_val) {
    int angle = ((adc_val * 180) / 4095) - 90; // Mapeia 0-4095 para -90 a +90
    servomotor_set_angle(angle);
}

/**
 * @brief Obtém o ângulo atual do servomotor.
 */
int servomotor_get_angle(void) {
    return current_angle;
}
