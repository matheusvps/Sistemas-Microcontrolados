; Desenvolvido para a placa EK-TM4C129EXL
; Matheus Passos, Lucas Yukio, João Castilho Cardoso

; -------------------------------------------------------------------------------
    THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------

;-----------------------------------------------------------------
; Área de Dados - Declarações de variáveis
    AREA DATA, READONLY, ALIGN=2
    ; Se alguma variável for chamada em outro arquivo
    ;EXPORT  var [DATA,SIZE=tam]   ; Permite chamar a variável var a partir de outro arquivo
;var	SPACE tam                     ; Declara uma variável de nome var de tam bytes a partir da primeira posição da RAM

; Tabela de segmentos para display de 7 segmentos
D7SEG_TABELA
    DCB 2_00111111  ; 0
    DCB 2_00000110  ; 1
    DCB 2_01011011  ; 2
    DCB 2_01001111  ; 3
    DCB 2_01100110  ; 4
    DCB 2_01101101  ; 5
    DCB 2_01111101  ; 6
    DCB 2_00000111  ; 7
    DCB 2_01111111  ; 8
    DCB 2_01101111  ; 9
    EXPORT D7SEG_TABELA [DATA,SIZE=10]  ; 10 bytes (1 por dígito)

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
    AREA |.text|, CODE, READONLY, ALIGN=2

    ; Se alguma função do arquivo for chamada em outro arquivo
    EXPORT Seg_Display ; Permite chamar a funçãoo Start a partir de outro arquivo. No caso startup.s

    ; Se chamar alguma função externa
    ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma função <func>
    IMPORT SysTick_Wait1us
    IMPORT SysTick_Wait1ms
    IMPORT PortA_Output
    IMPORT PortB_Output
    IMPORT PortQ_Output
    IMPORT Extract_Digits

; ----------------- --------------------------------------------------------------
; Função Seg_Display
; -------------------------------------------------------------------------------
; R0 -> dados temporários para serem enviados p/ port
; R1 -> armazena unidade temporariamente
; R2 -> armazena dezena temporariamente
; R3 -> valor da unidade de 0 a 9, para decodificação em formato de segmento
; R4 -> unidade no padrão de segmento
; R5 -> dezena no padrão de segmento
; R6 -> armazena endereço da tabela de 7seg
Seg_Display
    PUSH {R0, R1, R2, R3, LR}
    MOV R0, R4               	; R0 = contador (0–99)
    BL Extract_Digits        	; R1 = unidade, R2 = dezena
    LDR R3, =D7SEG_TABELA    	; Endereços dos segmentos para ativar

;--- Exibe a DEZENA (Q2) ---
    LDRB R0, [R3, R2]           ; R0 = padrão segmentos da dezena
    AND R0, R0, #2_00001111     ; Máscara para os 4 bits menos significativos
    BL PortQ_Output             ; Envia para o display de 7 segmentos
    LDRB R0, [R3, R2]           ; R0 = padrão segmentos da dezena
    AND R0, R0, #2_11110000     ; Máscara para os 4 bits mais significativos
    BL PortA_Output             ; Envia para o display de 7 segmentos
    MOV R0, #2_00100000
    BL PortB_Output             ; Envia para o transistor Q
    MOV R0, #1                  ; 1 ms
    BL SysTick_Wait1us          ; Espera 10ms
    MOV R0, #0
    BL PortB_Output             ; Desliga Q2
    MOV R0, #1                  ; 1 ms
    BL SysTick_Wait1us          ; Espera 10ms

;--- Exibe a UNIDADE (Q1) ---
    LDRB R0, [R3, R1]           ; R0 = padrão segmentos da dezena
    AND R0, R0, #2_00001111     ; Máscara para os 4 bits menos significativos
    BL PortQ_Output             ; Envia para o display de 7 segmentos
    LDRB R0, [R3, R1]           ; R0 = padrão segmentos da dezena
    AND R0, R0, #2_11110000     ; Máscara para os 4 bits mais significativos
    BL PortA_Output             ; Envia para o display de 7 segmentos
    MOV R0, #2_00010000
    BL PortB_Output             ; Envia para o transistor Q3 (dezena)
    MOV R0, #1                  ; 1 ms
    BL SysTick_Wait1us          ; Espera 10ms
    MOV R0, #0
    BL PortB_Output             ; Desliga Q3
    MOV R0, #1                  ; 1 ms
    BL SysTick_Wait1us          ; Espera 10ms

    POP {R0, R1, R2, R3, LR}
    BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------
    ALIGN                       ; Garante que o fim da seção está alinhado
    END                         ; Fim do arquivo
