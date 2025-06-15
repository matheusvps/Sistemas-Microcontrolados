// pwm.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef PWM_H
    #define PWM_H

    // C
    #include <stdint.h>

    /**
     * @brief Inicializa o PWM no pino PL4 usando o Timer 0A.
     */
    void pwm_init(void);

    /**
     * @brief Configura o duty cycle do PWM.
     */
    void pwm_set_high_ticks(uint32_t high_ticks);

    /**
     * @brief Converte um ângulo em ticks para o PWM.
     * @param angle Ângulo em graus (-90 a +90).
     * @return Ticks correspondentes ao ângulo.
     */
    uint32_t pwm_angle_to_ticks(int angle);

#endif // PWM_H
