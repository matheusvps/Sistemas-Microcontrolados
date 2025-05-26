// motor.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef __MOTOR_H__
#define __MOTOR_H__

#include <stdint.h>

// Registradores do GPIO Port E
#define GPIO_PORTE_DATA_R       (*((volatile uint32_t *)0x400243FC))
#define GPIO_PORTE_DIR_R        (*((volatile uint32_t *)0x40024400))
#define GPIO_PORTE_DEN_R        (*((volatile uint32_t *)0x4002451C))

// Funções exportadas
void Motor_Init(void);
void Motor_Move(int32_t angulo_destino);
void giraMotor(int graus, int direcao, int modo);

#endif // __MOTOR_H__
