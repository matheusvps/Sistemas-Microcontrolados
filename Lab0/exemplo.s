; lab0.s
; Desenvolvido para a placa EK-TM4C1294XL
; LAB 0 - Cifra de C�sar em Assembly com divis�o manual

        THUMB

; -------------------------------------------------------------------------------
; Defines
reading   EQU 0x20000400
writing   EQU 0x20000500

; -------------------------------------------------------------------------------
        AREA    DATA, ALIGN=2

; -------------------------------------------------------------------------------
        AREA    |.text|, CODE, READONLY, ALIGN=2

        EXPORT Start

Start
        ; Carrega os campos do header
        LDR     R0, =reading

        LDRB    R1, [R0]            ; operando1
        LDRB    R2, [R0, #1]        ; opera��o
        LDRB    R3, [R0, #2]        ; operando2
        LDRB    R4, [R0, #3]        ; tamanho da mensagem

        ; R5 = resultado da opera��o (chave)
        CMP     R2, #1
        BEQ     OP_ADICAO
        CMP     R2, #2
        BEQ     OP_SUBTRACAO
        CMP     R2, #3
        BEQ     OP_MULTIPLICACAO
        CMP     R2, #4
        BEQ     OP_DIVISAO

        ; opera��o inv�lida
        MOV     R5, #0
        B       DECRIPTOGRAFAR

OP_ADICAO
        ADD     R5, R1, R3
        B       DECRIPTOGRAFAR

OP_SUBTRACAO
        SUB     R5, R1, R3
        B       DECRIPTOGRAFAR

OP_MULTIPLICACAO
        MUL     R5, R1, R3
        B       DECRIPTOGRAFAR

OP_DIVISAO
        ; Divis�o inteira manual: R1 / R3 ? resultado em R5
        MOV     R5, #0              ; quociente = 0
        MOV     R6, R1              ; R6 = dividendo
        MOV     R7, R3              ; R7 = divisor

DIV_LOOP
        CMP     R6, R7              ; enquanto R6 >= R7
        BLT     DECRIPTOGRAFAR
        SUB     R6, R6, R7
        ADD     R5, R5, #1
        B       DIV_LOOP

; -------------------------------------------------------------------------------
; Decripta��o com Cifra de C�sar
DECRIPTOGRAFAR
        LDR     R6, =reading
        ADD     R6, R6, #4          ; in�cio da mensagem cifrada
        LDR     R7, =writing
        STRB    R4, [R7]            ; salva o tamanho no destino
        ADD     R7, R7, #1          ; pr�ximo endere�o de escrita

        MOV     R8, #0              ; �ndice

LOOP
        CMP     R8, R4              ; fim da mensagem?
        BGE     FIM

        LDRB    R9, [R6, R8]        ; caractere cifrado
        SUB     R9, R9, R5          ; aplica cifra de C�sar (subtrai chave)

        CMP     R9, #0x41           ; menor que 'A'?
        BGE     ARMAZENAR
        ADD     R9, R9, #26         ; d� a volta no alfabeto

ARMAZENAR
        STRB    R9, [R7, R8]        ; armazena caractere decodificado

        ADD     R8, R8, #1
        B       LOOP

FIM
        B       FIM                 ; loop infinito

        ALIGN
        END
