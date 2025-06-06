// motor.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef MOTOR_H
    #define MOTOR_H

    /**
     * @brief Atualiza o display durante o giro do motor
     * @param angulo_atual Ângulo atual do motor
     * @param direcao Direção de rotação (1 para horário, -1 para anti-horário)
     * @param velocidade Velocidade de rotação (1 para passo completo, 2 para meio passo)
     */
    void atualizar_display_giro(int angulo_atual, int direcao, int velocidade);

    /**
     * @brief Gira o motor de passo.
     * @param graus O número de graus que o motor deve girar.
     * @param direcao A direção de rotação (1 para horário, -1 para anti-horário).
     * @param modo O modo de operação (1 para passo completo, 2 para meio passo).
     */
    void giraMotor(int graus, int direcao, int modo);

#endif
