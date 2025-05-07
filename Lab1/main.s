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

;-----------------------------------------------------------------
; VARIÁVEIS EM REGISTRADORES
; R4 = contador (0-99)
; R5 = passo     (1-9)
; R6 = modo      (0=crescente,1=decrescente)
;-----------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  var [DATA,SIZE=tam]   ; Permite chamar a variável var a 
		                             ; partir de outro arquivo
;var	SPACE tam                     ; Declara uma variável de nome var
                                     ; de tam bytes a partir da primeira 
                                     ; posição da RAM		
String_Passo        DCB "Passo: ",0
		EXPORT String_Passo [DATA,SIZE=8]    
		
String_Crescente    DCB "Crescente",0
		EXPORT String_Crescente [DATA,SIZE=10]
		
String_Decrescente  DCB "Decrescente",0
		EXPORT String_Decrescente [DATA,SIZE=12]
			
			; Tabela de segmentos para display de 7 segmentos
D7SEG_TABELA
        DCB 0x3F    ; 0
        DCB 0x06    ; 1
        DCB 0x5B    ; 2
        DCB 0x4F    ; 3
        DCB 0x66    ; 4
        DCB 0x6D    ; 5
        DCB 0x7D    ; 6
        DCB 0x07    ; 7
        DCB 0x7F    ; 8
        DCB 0x6F    ; 9
        EXPORT D7SEG_TABELA [DATA,SIZE=10]  ; 10 bytes (1 por dígito)	
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
		IMPORT 	PortK_Output
		IMPORT	PortM_Output
		IMPORT 	PortQ_Output
        IMPORT  Seg_Display


; -------------------------------------------------------------------------------
; Fun��o main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL LCD_Init

	MOV R5, #1

Loop7segTeste
    MOV R0, #0x00
    BL Seg_Display
    MOV R0, #0x01
    BL Seg_Display
    MOV R0, #0x02
    BL Seg_Display
    MOV R0, #0x03
    BL Seg_Display
    MOV R0, #0x04
    BL Seg_Display
    MOV R0, #0x05
    BL Seg_Display
    MOV R0, #0x06
    BL Seg_Display
    MOV R0, #0x07
    BL Seg_Display
    MOV R0, #0x08
    BL Seg_Display
    MOV R0, #0x09
    BL Seg_Display
    B Loop7segTeste

; LoopTeste
; 	MOV R0, #39
; 	BL LCD_WriteNumber
;     B LoopTeste

MainLoop
    CMP R6, #0
    BEQ IncrementaContagem
VOLTA_INCREMENTA
    CMP R6, #0
    BNE DecrementaContagem
VOLTA_DECREMENTA
    BL LCD_Display       ; Mostrar string do estado atual no LCD
    B MainLoop

IncrementaContagem
    ADD R4, R4, R5
    CMP R4, #100
    BLE VOLTA_INCREMENTA
    SUB R4, R4, #100
    B VOLTA_INCREMENTA    ; Usar B em vez de BX LR

DecrementaContagem
    SUB R4, R4, R5
    CMP R4, #0
    BGE VOLTA_DECREMENTA
    ADD R4, R4, #100
    B VOLTA_DECREMENTA    ; Usar B em vez de BX LR


;--------------------------------------------------------------------------------
; Função LCD_Init
; Inicializa os valores necessários para configurar o LCD
LCD_Init
	PUSH {R0, LR}
    MOV R0, #0x38                  ; Configuração do modo de 8 bits, 2 linhas, 5x8 pontos
	BL LCD_Helper				   ; Envia para o LCD
    MOV R0, #0x06                  ; Deslocamento automático do cursor para a direita ao entrar com caracter
	BL LCD_Helper				   ; Envia para o LCD
    MOV R0, #0x0E                  ; Liga o display e o cursor
    BL LCD_Helper				   ; Envia para o LCD
    MOV R0, #0x0D                  ; Configura cursor piscante
	BL LCD_Helper				   ; Envia para o LCD
    MOV R0, #0x01                  ; Comando para limpar o display
	BL LCD_Helper				   ; Envia para o LCD
    MOV R0, #1600                  ; Valor de delay para inicialização (em us)
	BL SysTick_Wait1us             ; Aguarda 1600us (tempo de execução do comando)
	POP {R0, LR}
	BX LR

;--------------------------------------------------------------------------------
; Função LCD_Helper
; Envia comando de R0 para o LCD usando PORTK e PORTM
LCD_Helper
    PUSH {R0, LR}                  ; Salva o registrador LR na pilha
    BL PortK_Output                ; Envia o sinal de R0 para o PK
    MOV R0, #2_101                 ; Configura o sinal de controle RS=1, RW=0, EN=1
    BL PortM_Output                ; Envia o sinal de habilitação para o PM
    MOV R0, #10
	BL SysTick_Wait1us             ; Aguarda 10us (tempo para Enable)
    MOV R0, #2_100                 ; Limpa o sinal de habilitação RS=1, RW=0, EN=0
    BL PortM_Output                ; Envia o sinal de controle para o PM
	MOV R0, #40
    BL SysTick_Wait1us             ; Aguarda 40us (tempo de execução do comando)
    POP {R0, LR}                   ; Restaura o registrador LR da pilha
    BX LR                          ; Retorna da função
	
; -------------------------------------------------------------------------------
; Função LCD_WriteNumber
; Converte um número em ASCII e envia para o LCD
; Parâmetro de entrada: R0 --> Número a ser exibido
LCD_WriteNumber
    PUSH {R0, R1, R2, R3, LR}       ; Salva os registradores usados
    MOV R1, #10                     ; Divisor = 10
    UDIV R2, R0, R1                 ; R2 = R0 / 10 (dezena)
    MLS R3, R2, R1, R0              ; R3 = R0 - (R2 * 10) (unidade)
    ADD R2, R2, #48                 ; Converte para ASCII ('0' = 48)
    MOV R0, R2                      ; Move a dezena para R0
    BL LCD_Helper                   ; Envia a dezena para o LCD
    ADD R3, R3, #48                 ; Converte para ASCII ('0' = 48)
    MOV R0, R3                      ; Move a unidade para R0
    BL LCD_Helper                   ; Envia a unidade para o LCD
    POP {R0, R1, R2, R3, LR}        ; Restaura os registradores usados
    BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_WriteString
; Envia uma string para o LCD
; Parâmetro de entrada: R0 --> Endereço da string
LCD_WriteString
    PUSH {R0, R1, LR}               ; Salva o registrador LR na pilha

Write_Loop
    LDRB R1, [R0], #1               ; Lê o próximo caractere da string e incrementa o ponteiro
    CMP R1, #0                      ; Verifica se é o caractere nulo (fim da string)
    BEQ Write_End                   ; Se for nulo, termina a função
    BL LCD_Helper                   ; Envia o caractere para o LCD
    B Write_Loop                    ; Continua enviando os próximos caracteres

Write_End
    POP {R0, R1, LR}                ; Restaura o registrador LR da pilha
    BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_Display
; Mostra na tela o valor do passo e o modo (Crescente ou Decrescente)
LCD_Display
	PUSH {LR}
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
    POP {LR}
	BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo