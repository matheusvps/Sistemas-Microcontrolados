// systick.h
// Desenvolvido para a placa EK-TM4C129EXL
// Matheus Passos, Lucas Yukio, João Castilho Cardoso

#ifndef SYSTICK_H
    #define SYSTICK_H

    /**
     * @brief Inicializa o SysTick.
     */
    void SysTick_Init(void);
    
    /**
     * @brief Espera um determinado número de milissegundos.
     * @param delay O número de milissegundos a esperar.
     */
    void SysTick_Wait1ms(uint32_t delay);

    /**
     * @brief Espera um determinado número de microssegundos.
     * @param delay O número de microssegundos a esperar.
     */
    void SysTick_Wait1us(uint32_t delay);

#endif // SYSTICK_H
