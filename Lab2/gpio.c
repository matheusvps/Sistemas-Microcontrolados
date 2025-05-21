// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron


#include <stdint.h>

#include "tm4c1294ncpdt.h"

void SysTick_Wait1ms(uint32_t delay);
void PortN_Output(uint32_t leds);

#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12

// -------------------------------------------------------------------------------
// Fun��o GPIO_Init
// Inicializa os ports J e N
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: N�o tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R = (GPIO_PORTJ | GPIO_PORTN);
	//1b.   ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
  while((SYSCTL_PRGPIO_R & (GPIO_PORTJ | GPIO_PORTN) ) != (GPIO_PORTJ | GPIO_PORTN) ){};
	
	// 2. Limpar o AMSEL para desabilitar a anal�gica
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTN_AMSEL_R = 0x00;
		
	// 3. Limpar PCTL para selecionar o GPIO
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTN_PCTL_R = 0x00;

	// 4. DIR para 0 se for entrada, 1 se for sa�da
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	GPIO_PORTN_DIR_R = 0x03; //BIT0 | BIT1
		
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem fun��o alternativa	
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTN_AFSEL_R = 0x00; 
		
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTJ_AHB_DEN_R = 0x03;   //Bit0 e bit1
	GPIO_PORTN_DEN_R = 0x03; 		   //Bit0 e bit1
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1	

}	

// -------------------------------------------------------------------------------
// Fun��o PortJ_Input
// L� os valores de entrada do port J
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: o valor da leitura do port
uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_AHB_DATA_R;
}

//Função Timer_Init
//Inicializa os valores do timer para que seja ativado posteriormente
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: Nâo tem
void Timer_Init(void){

	// Seta o bit do timer 2 para uso
	SYSCTL_RCGCTIMER_R = 4;
	
	// Testa até o bit do timer 2 ser setado
	while(SYSCTL_PRTIMER_R != 4);
	
	//Desabilita timer 2 para configuração
	TIMER2_CTL_R = 0;
	
	//Seta para modo de 32 bits
	TIMER2_CFG_R = 0x00;

	//Seta para modo periódico
	TIMER2_TAMR_R = 2;

	//Valor de contagem de 100ms para timer e setando prescale para 0
	TIMER2_TAILR_R = 1199999999;
	TIMER2_TAPR_R = 0;

	//Limpa flag de interrupção
	TIMER2_ICR_R = 1;

	//Seta interrupção no timer
	TIMER2_IMR_R = 1;

	//Seta prioridade e habilita a interrupção
	NVIC_PRI5_R = 4 << 29;
	NVIC_EN0_R = 1 << 23;

}


//Função Timer_Start
//Inicia a contagem do timer
// Par�metro de entrada: Não tem
// Par�metro de sa�da: Nâo tem
void Timer_Start(void){
	//Limpa flag de interrupção
	TIMER2_ICR_R = 1;

	//Liga o timer
	TIMER2_CTL_R = 1;
}

//Função Timer_Stop
//Para a contagem do timer
// Par�metro de entrada: Não tem
// Par�metro de sa�da: Nâo tem
void Timer_Stop(void){
	//Limpa flag de interrupção
	TIMER2_ICR_R = 1;

	//Desliga o timer
	TIMER2_CTL_R = 0;
}

//Função Timer2A_Handler
//É chamada quando a contagem do timer zera
// Par�metro de entrada: Não tem
// Par�metro de sa�da: Nâo tem
void Timer2A_Handler(void){

	//Limpa a flag de interrupções
	TIMER2_ICR_R = 1;

	//Pisca o LED 1 da placa
	PortN_Output(0x1);
	SysTick_Wait1ms(2);
	PortN_Output(0x0);
}


// -------------------------------------------------------------------------------
// Fun��o PortN_Output
// Escreve os valores no port N
// Par�metro de entrada: Valor a ser escrito
// Par�metro de sa�da: n�o tem
void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amig�vel nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC;
    //agora vamos fazer o OR com o valor recebido na fun��o
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}




