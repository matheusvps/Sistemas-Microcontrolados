; Desenvolvido para a placa EK-TM4C129EXL
; Matheus Passos, Lucas Yukio, João Castilho Cardoso

; Contagem de 0 a 99 nos displays de 7 segmentos, passo ajustável por USR_SW1, modo inversão por USR_SW2

; -------------------------------------------------------------------------------
    THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

;-----------------------------------------------------------------
; DEFINES
;-----------------------------------------------------------------

MS250_IN_US EQU 100000

;-----------------------------------------------------------------
; Área de Dados - Declarações de variáveis
    AREA DATA, READONLY, ALIGN=2
    ; Se alguma variável for chamada em outro arquivo
    ;EXPORT  var [DATA,SIZE=tam]   ; Permite chamar a variável var a partir de outro arquivo
;var	SPACE tam                  ; Declara uma variável de nome var de tam bytes a partir da primeira posição da RAM

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
    AREA    |.text|, CODE, READONLY, ALIGN=2

    ; Se alguma função do arquivo for chamada em outro arquivo	
    EXPORT Start                ; Permite chamar a função Start a partir de outro arquivo. No caso startup.s

    ; Se chamar alguma função externa	
    ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma função <func>
    IMPORT PLL_Init
    IMPORT SysTick_Init
    IMPORT GPIO_Init
    IMPORT LCD_Init
    IMPORT LCD_Display
    IMPORT LCD_WriteNumber
    IMPORT Seg_Display

;-----------------------------------------------------------------
; VARIÁVEIS EM REGISTRADORES
; R4 = contador (0-99)
; R5 = passo    (1-9)
; R6 = modo     (0=crescente,1=decrescente)
; -------------------------------------------------------------------------------
; Função main()
Start
    BL PLL_Init        ; Configura clock para 80MHz
    BL SysTick_Init    ; Inicializa SysTick
    BL GPIO_Init       ; Geral GPIO (inclui PortJ_Init)
    BL LCD_Init        ; Inicializa LCD

    MOV R5, #1         ; Passo inicial = 1
    MOV R6, #0         ; Modo inicial = crescente   
    LDR R8, =MS250_IN_US ; Tempo de contagem (200000 x 5µs = 1s)
; LoopTeste
;  	MOV R0, #39
;  	BL LCD_WriteNumber
;     B LoopTeste
MainLoop
    MOV R7, #0         ; Cronômetro
ShowOnDisplay
    BL Seg_Display     ; Exibe número no display de 7 segmentos
    ADD R7, R7, #1     ; Incrementa cronômetro
    CMP R7, R8         ; Verifica se passou 1s
    BLT ShowOnDisplay  ; Enquanto não passou 1s

    ; Atualiza contador conforme modo
    CMP R6, #0
    BEQ DoIncrement
    SUB R4, R4, R5     ; modo decrescente
    B CheckUnderflow
DoIncrement
    ADD R4, R4, R5     ; modo crescente
    CMP R4, #100
    BLE ContinueLoop
    SUB R4, R4, #100
    B ContinueLoop

CheckUnderflow
    CMP R4, #0
    BGE ContinueLoop
    ADD R4, R4, #100

ContinueLoop
    B MainLoop
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                           ; Garante que o fim da seção está alinhado 
    END                             ; Fim do arquivo
