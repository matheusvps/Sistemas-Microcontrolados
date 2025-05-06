; Desenvolvido para a placa EK-TM4C129EXL
; Matheus Passos, Lucas Yukio, João Castilho Cardoso
; 24/08/2020
; Contagem de 0 a 99 nos displays de 7 segmentos, passo ajustável por USR_SW1, modo inversão por USR_SW2

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
;-----------------------------------------------------------------
; DEFINES
;-----------------------------------------------------------------

; GPIO Port B (transistores Q1,Q2)
GPIO_PORTB_AHB_DATA_R  EQU 0x4005C3FC
GPIO_PORTB_AHB_DIR_R   EQU 0x4005C400
GPIO_PORTB_AHB_DEN_R   EQU 0x4005C51C

; GPIO Port J (botões)
GPIO_PORTJ_AHB_DATA_R  EQU 0x400603FC
GPIO_PORTJ_AHB_DIR_R   EQU 0x40060400
GPIO_PORTJ_AHB_DEN_R   EQU 0x4006051C
GPIO_PORTJ_AHB_PUR_R   EQU 0x40060510
GPIO_PORTJ_AHB_IS_R    EQU 0x40060404
GPIO_PORTJ_AHB_IBE_R   EQU 0x40060408
GPIO_PORTJ_AHB_IEV_R   EQU 0x4006040C
GPIO_PORTJ_AHB_IM_R    EQU 0x40060410
GPIO_PORTJ_AHB_RIS_R   EQU 0x40060514
GPIO_PORTJ_AHB_ICR_R   EQU 0x4006041C

; NVIC GPIOJ interrupt
INT_GPIOJ              EQU 51

; Delay constants
DELAY1MS               EQU 80000  ; SysTick loops

;-----------------------------------------------------------------
; VARIÁVEIS EM REGISTRADORES
; R4 = contador (0-99)
; R5 = passo     (1-9)
; R6 = modo      (0=crescente,1=decrescente)
;-----------------------------------------------------------------

; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		
		String_Passo		DCB	"Passo: ", 0	
		String_Crescente	DCB	"Crescente", 0
		String_Decrescente	DCB "Decrescente", 0

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT 	SysTick_Wait1us	
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT 	PortB_Output
        IMPORT  PortJ_Input
		IMPORT 	PortK_Output
		IMPORT	PortM_Output
		IMPORT 	PortQ_Output


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO


MainLoop
	BL PortJ_Input				 ;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
	; extrai dezena e unidade
	MOV     R0, R4
	MOV     R1, #10
	UDIV    R2, R0, R1      ; R2 = dezena
  	MLS     R3, R2, R1, R0  ; R3 = unidade
	
Verifica_Nenhuma
	CMP	R0, #2_00000001			 ;Verifica se nenhuma chave est� pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	MOV R0, #0                   ;N�o acender nenhum LED
	BL PortN_Output			 	 ;Chamar a fun��o para n�o acender nenhum LED
	B MainLoop					 ;Se o teste viu que nenhuma chave est� pressionada, volta para o la�o principal
Verifica_SW1	
	CMP R0, #2_00000000			 ;Verifica se somente a chave SW1 est� pressionada
	BNE MainLoop                 ;Se o teste falhou, volta para o in�cio do la�o principal
	BL IncrementaPasso  		 ;Chama a rotina para incrementar o passo da contagem
	B MainLoop                   ;Volta para o la�o principal
Verifica_SW2
    CMP R0, #2_00000010        	 ;Verifica se somente a chave SW2 está pressionada (bit 1 = 0)
	BNE MainLoop               	 ;Se não for exatamente isso, volta para o laço principal
	BL AlternaModo             	 ;Chama a rotina para piscar o LED
	B MainLoop                 	 ;Volta para o laço principal
IncrementaPasso
	ADD R5, R5, #1
	CMP R5, #9
	BLE MainLoop
	SUB R5, R5, 9
	B MainLoop
IncrementaContagem
	ADD R4, R4, R5               ;Incrementa o contador de acordo com o passo
	CMP R4, #100                 ;Verifica se o contador est� maior que 99
	BLE MainLoop		 		 ;Se o contador for menor ou igual a 99, pula para a rotina de verifica��o do contador
	SUB R4, R4, #100			 ;Se o contador for maior que 99, subtrai 100 do contador
	B MainLoop                   ;Volta para o laço principal
DecrementaContagem
	SUB R4, R4, R5               ;Decrementa o contador de acordo com o passo
	CMP R4, #0                   ;Verifica se o contador est� menor que 0
	BGE MainLoop                 ;Se o contador for maior ou igual a 0, pula para a rotina de verifica��o do contador
	ADD R4, R4, #100             ;Se o contador for menor que 0, soma 100 ao contador
	B MainLoop                   ;Volta para o la�o principal

AlternaModo
	CMP R6, #0
	ITE EQ
	MOVEQ R6, #1                 ; Se R6 = 0, muda o modo para 1
	MOVNE R6, #0                 ; Se R6 = 1, muda o modo para 0
	BX LR                        ; Retorno




;--------------------------------------------------------------------------------
; Função LCD_Init
; Inicializa os valores necessários para configurar o LCD
LCD_Init
    MOV R0, #0x38                  ; Configuração do modo de 8 bits, 2 linhas, 5x8 pontos
	BL LCD_Helper				   ; Envia para o LCD
	BL SysTick_Wait1ms             ; Aguarda o diaplay atualizar
    MOV R0, #0x06                  ; Configuração de incremento automático do cursor
	BL LCD_Helper				   ; Envia para o LCD
	BL SysTick_Wait1ms             ; Aguarda o diaplay atualizar
    MOV R0, #0x0E                  ; Liga o display e o cursor
	BL LCD_Helper				   ; Envia para o LCD
	BL SysTick_Wait1ms             ; Aguarda o diaplay atualizar
    MOV R0, #0x01                  ; Comando para limpar o display
	BL LCD_Helper				   ; Envia para o LCD
	BL SysTick_Wait1ms             ; Aguarda o diaplay atualizar
    MOV R0, #1640                  ; Valor de delay para inicialização (em us)
	BL LCD_Helper				   ; Envia para o LCD
	BL SysTick_Wait1ms             ; Aguarda o diaplay atualizar
	BX LR

;--------------------------------------------------------------------------------
; Função LCD_Helper
; Envia comandos para o LCD usando PORTK e PORTM
LCD_Helper
    PUSH {LR}                      ; Salva o registrador LR na pilha
    BL PortK_Output                ; Envia o sinal de controle para o PK
    MOV R1, #0x04                  ; Configura o sinal de controle RS=1, RW=0, E=1 (binary: 0b00000100)
    BL PortM_Output                ; Envia o sinal de controle para o PM
    BL SysTick_Wait1us             ; Aguarda 1us (largura do pulso Enable)
    MOV R1, #0x00                  ; Limpa o sinal de habilitação RS=1, RW=0, E=0 (binary: 0b00000000)
    BL PortM_Output                ; Envia o sinal de controle para o PM
    BL SysTick_Wait1us             ; Aguarda 40us (tempo de execução do comando)
    POP {LR}                       ; Restaura o registrador LR da pilha
    BX LR                          ; Retorna da função
	
; -------------------------------------------------------------------------------
; Função LCD_WriteNumber
; Converte um número em ASCII e envia para o LCD
; Parâmetro de entrada: R0 --> Número a ser exibido
LCD_WriteNumber
    PUSH {R1, R2, R3, LR}           ; Salva os registradores usados
    MOV R1, #10                     ; Divisor = 10
    UDIV R2, R0, R1                 ; R2 = R0 / 10 (dezena)
    MLS R3, R2, R1, R0              ; R3 = R0 - (R2 * 10) (unidade)
    ADD R2, R2, #48                 ; Converte para ASCII ('0' = 48)
    MOV R0, R2                      ; Move a dezena para R0
    BL LCD_Helper                   ; Envia a dezena para o LCD
    ADD R3, R3, #48                 ; Converte para ASCII ('0' = 48)
    MOV R0, R3                      ; Move a unidade para R0
    BL LCD_Helper                   ; Envia a unidade para o LCD
    POP {R1, R2, R3, LR}            ; Restaura os registradores usados
    BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_WriteString
; Envia uma string para o LCD
; Parâmetro de entrada: R0 --> Endereço da string
LCD_WriteString
    PUSH {LR}                       ; Salva o registrador LR na pilha

Write_Loop
    LDRB R1, [R0], #1               ; Lê o próximo caractere da string e incrementa o ponteiro
    CMP R1, #0                      ; Verifica se é o caractere nulo (fim da string)
    BEQ Write_End                   ; Se for nulo, termina a função
    BL LCD_Helper                   ; Envia o caractere para o LCD
    B Write_Loop                    ; Continua enviando os próximos caracteres

Write_End
    POP {LR}                        ; Restaura o registrador LR da pilha
    BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_Display
; Mostra na tela o valor do passo e o modo (Crescente ou Decrescente)
LCD_Display
    PUSH {LR}                       ; Salva o registrador LR na pilha
    LDR R0, =String_Passo           ; Carrega o endereço da string "Passo: "
    BL LCD_WriteString              ; Envia a string para o LCD
    MOV R0, R5                      ; Carrega o valor do passo em R0
    BL LCD_WriteNumber              ; Envia o valor do passo para o LCD
    MOV R0, #0xC0                   ; Comando para mover o cursor para a segunda linha
    BL LCD_Helper                   ; Envia o comando para o LCD
    CMP R6, #0                      ; Verifica o modo (0 = crescente, 1 = decrescente)
    BEQ Modo_Crescente              ; Se for 0, exibe "Crescente"
    LDR R0, =String_Decrescente     ; Caso contrário, carrega "Decrescente"
    B Modo_Exibir

Modo_Crescente
    LDR R0, =String_Crescente       ; Carrega o endereço da string "Crescente"

Modo_Exibir
    BL LCD_WriteString              ; Envia a string para o LCD
    POP {LR}                        ; Restaura o registrador LR da pilha
    BX LR                           ; Retorna da função

;--------------------------------------------------------------------------------
; Função Seg_Display
; Mostra no display de 7 segmentos (0–99) nos dígitos multiplexados via PB4/Q1 e PB5/Q2
; Entrada: R0 = valor atual (0–99)
; Usa: R1–R3 para dezena/unidade, R4 = endereço da tabela, R5 = código de segmentos
;--------------------------------------------------------------------------------
Seg_Display
    PUSH    {R0-R5, LR}

    ; Separa dezena e unidade
    MOV     R1, R0           ; R1 = valor
    MOV     R2, #10
    UDIV    R3, R1, R2       ; R3 = dezena = R1 / 10
    MLS     R1, R3, R2, R0   ; R1 = unidade = R0 - (R3 * 10)

    LDR     R4, =D7SEG_TABELA

    ; --- Unidade no display 1 (Q1, PB4) ---
    LDRB    R5, [R4, R1]     ; busca padrão de segmentos para unidade
    MOV     R0, R5
    BL      PortA_Output     ; coloca bits em PA7–PA4/PQ3–PQ0
    MOV     R0, #0x01        ; ativa Q1 (bit PB4)
    BL      PortB_Output
    BL      SysTick_Wait1ms  ; ~1 ms
    MOV     R0, #0x00        ; desativa Q1
    BL      PortB_Output
    BL      SysTick_Wait1ms

    ; --- Dezena no display 2 (Q2, PB5) ---
    LDRB    R5, [R4, R3]     ; busca padrão para dezena
    MOV     R0, R5
    BL      PortA_Output
    MOV     R0, #0x02        ; ativa Q2 (bit PB5)
    BL      PortB_Output
    BL      SysTick_Wait1ms
    MOV     R0, #0x00        ; desativa Q2
    BL      PortB_Output
    BL      SysTick_Wait1ms

    POP     {R0-R5, LR}
    BX      LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo