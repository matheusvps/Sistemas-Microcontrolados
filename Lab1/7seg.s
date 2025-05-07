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

; Máscaras dos transistores Q1/Q2 em PB4/PB5
TRANSISTOR_Q1  EQU 0x10    ; PB4 (unidade)
TRANSISTOR_Q2  EQU 0x20    ; PB5 (dezena)

;-----------------------------------------------------------------
; VARIÁVEIS EM REGISTRADORES
; R4 = contador (0-99)
; R5 = passo     (1-9)
; R6 = modo      (0=crescente,1=decrescente)
;-----------------------------------------------------------------
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Seg_Display                ; Permite chamar a fun��o Start a partir de 
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
		IMPORT 	PortQ_Output
    IMPORT D7SEG_TABELA
    
; -------------------------------------------------------------------------------
; R0 -> dados temporários para serem enviados p/ port
; R1 -> armazena unidade temporariamente
; R2 -> armazena dezena temporariamente
; R3 -> valor da unidade de 0 a 9, para decodificação em formato de segmento
; R4 -> unidade no padrão de segmento
; R5 -> dezena no padrão de segmento
; R6 -> armazena endereço da tabela de 7seg
        ;-------------------------------------------------------
        ; Função Seg_Display
        ;-------------------------------------------------------

        
        
; -----------------------------------------------------------------
Seg_Display
        PUSH    {R1-R6, LR}

        ;--- separa dezena e unidade a partir de R4 ---
        MOV     R0, R4          ; R0 = contador (0–99)
        MOV     R1, #10
        UDIV    R2, R0, R1      ; R2 = dezena
        MLS     R3, R2, R1, R0  ; R3 = unidade

        LDR     R6, =D7SEG_TABELA

    ;--- exibe a DEZENA (Q2) ---   
        LDRB    R5, [R6, R2]     ; R5 = padrão segmentos da dezena

        AND     R0, R5, #0xF0    ; isola bits PA7–PA4
        BL      PortA_Output

        AND     R0, R5, #0x0F    ; isola bits PQ3–PQ0
        BL      PortQ_Output

        MOV     R0, #TRANSISTOR_Q2
        BL      PortB_Output     ; liga Q2
        MOV     R0, #1
        BL      SysTick_Wait1ms
        MOV     R0, #0
        BL      PortB_Output     ; desliga Q2
        MOV     R0, #1
        BL      SysTick_Wait1ms

    ;--- exibe a UNIDADE (Q1) ---
        LDRB    R5, [R6, R3]     ; R5 = padrão segmentos da unidade

        AND     R0, R5, #0xF0
        BL      PortA_Output

        AND     R0, R5, #0x0F
        BL      PortQ_Output

        MOV     R0, #TRANSISTOR_Q1
        BL      PortB_Output     ; liga Q1
        MOV     R0, #1
        BL      SysTick_Wait1ms
        MOV     R0, #0
        BL      PortB_Output     ; desliga Q1
        MOV     R0, #1
        BL      SysTick_Wait1ms

        POP     {R1-R6, LR}
        BX      LR
        
    ALIGN                               ; garante que o fim da se��o est� alinhada 
    END                                 ; fim do arquivo
