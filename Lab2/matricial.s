;teclado.s
; Desenvolvido para a placa EK-TM4C1294XL
; Matheus Passos, Lucas Yukio, Joao Pedro

; -------------------------------------------------------------------------------
        THUMB                        ; Instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declaracoes EQU - Defines
; ========================
TECLADO_PRESS_ADDR          EQU     0x20000B00

; ~~~~~~~~~~~~~~~~ PORT L ~~~~~~~~~~~~~~~~~~
GPIO_PORTL_DATA_R           EQU     0x400623FC
GPIO_PORTL_DIR_R            EQU     0x40062400
GPIO_PORTL_AFSEL_R          EQU     0x40062420
GPIO_PORTL_PUR_R            EQU     0x40062510
GPIO_PORTL_PDR_R            EQU     0x40062514
GPIO_PORTL_DEN_R            EQU     0x4006251C
GPIO_PORTL_LOCK_R           EQU     0x40062520
GPIO_PORTL_CR_R             EQU     0x40062524
GPIO_PORTL_AMSEL_R          EQU     0x40062528
GPIO_PORTL_PCTL_R           EQU     0x4006252C
GPIO_PORTL               	EQU    2_000010000000000

; ~~~~~~~~~~~~~~~~ PORT M ~~~~~~~~~~~~~~~~~~
GPIO_PORTM_DATA_R           EQU     0x400633FC
GPIO_PORTM_DIR_R            EQU     0x40063400
GPIO_PORTM_AFSEL_R          EQU     0x40063420
GPIO_PORTM_PUR_R            EQU     0x40063510
GPIO_PORTM_DEN_R            EQU     0x4006351C
GPIO_PORTM_LOCK_R           EQU     0x40063520
GPIO_PORTM_CR_R             EQU     0x40063524
GPIO_PORTM_AMSEL_R          EQU     0x40063528
GPIO_PORTM_PCTL_R           EQU     0x4006352C
GPIO_PORTM               	EQU    2_000100000000000

; -------------------------------------------------------------------------------
; Area de Codigo - Tudo abaixo da diretiva a seguir sera armazenado na memoria de 
;                  codigo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma funcao do arquivo for chamada em outro arquivo	
        EXPORT TecladoM_Poll

; -------------------------------------------------------------------------------
; Funcao TecladoM_Poll
; Retorna o digito da 1a tecla pressionada. Pinos L0-L3 sao entrada e M4-M7 sao saida.
; Saida: R1 -> Valor da tecla pressionada (0xF se nenhuma for pressionada)
TecladoM_Poll
            MOV     R2, #2_10000000
            
loop_columns
            MOV     R1, #0x10                                ; Seta a saida para 10 pois a tecla 10 nao existe
            CMP     R2, #2_00001000
            BLS     teclado_retorno
            
            LDR     R0, =GPIO_PORTM_DATA_R                  ; Habilita o Pino de R2
            STR     R2, [R0]

            LDR     R0, =GPIO_PORTL_DATA_R                  ; Leitura dos dados
            LDR     R1, [R0]

            ; Verifica se alguma tecla foi apertada e retorna
            CMP     R1, #2_1000                             ; Verifica se o pino L3 esta ativo (teclas *, 0, # e D)
            BEQ     teclado_decode

            CMP     R1, #2_0100                             ; Verifica se o pino L2 esta ativo (teclas 7, 8, 9 e C)
            BEQ     teclado_decode

            CMP     R1, #2_0010                             ; Verifica se o pino L1 esta ativo (teclas 4, 5, 6 e B)
            BEQ     teclado_decode

            CMP     R1, #2_0001                             ; Verifica se o pino L0 esta ativo (teclas 1, 2, 3 e A)
            BEQ     teclado_decode

            LSR     R2, R2, #1
            B       loop_columns

teclado_decode
            ; Decodifica a relacao coluna-linha para determinar qual tecla foi pressionada
            CMP     R2, #2_00010000
            BEQ     decode_coluna_1

            CMP     R2, #2_00100000
            BEQ     decode_coluna_2

            CMP     R2, #2_01000000
            BEQ     decode_coluna_3

            CMP     R2, #2_10000000
            BEQ     decode_coluna_4

decode_coluna_1
            CMP     R1, #2_1000                                 ; Tecla *
            IT      EQ
            MOVEQ   R1, #2_00101010

            CMP     R1, #2_0100                                 ; Tecla 7
            IT      EQ
            MOVEQ   R1, #0x37

            CMP     R1, #2_0010                                 ; Tecla 4
            IT      EQ
            MOVEQ   R1, #0x34

            CMP     R1, #2_0001                                 ; Tecla 1
            IT      EQ
            MOVEQ   R1, #0x31

            B       teclado_retorno

decode_coluna_2
            CMP     R1, #2_1000                                 ; Tecla 0
            IT      EQ
            MOVEQ   R1, #0x30

            CMP     R1, #2_0100                                 ; Tecla 8
            IT      EQ
            MOVEQ   R1, #0x38

            CMP     R1, #2_0010                                 ; Tecla 5
            IT      EQ
            MOVEQ   R1, #0x35

            CMP     R1, #2_0001                                 ; Tecla 2
            IT      EQ
            MOVEQ   R1, #0x32

            B       teclado_retorno

decode_coluna_3
            CMP     R1, #2_1000                                 ; Tecla #
            IT      EQ
            MOVEQ   R1, #2_00100011

            CMP     R1, #2_0100                                 ; Tecla 9
            IT      EQ
            MOVEQ   R1, #0x39

            CMP     R1, #2_0010                                 ; Tecla 6
            IT      EQ
            MOVEQ   R1, #0x36

            CMP     R1, #2_0001                                 ; Tecla 3
            IT      EQ
            MOVEQ   R1, #0x33

            B       teclado_retorno

decode_coluna_4
            CMP     R1, #2_1000                                 ; Tecla D
            IT      EQ
            MOVEQ   R1, #2_01000100

            CMP     R1, #2_0100                                 ; Tecla C
            IT      EQ
            MOVEQ   R1, #2_01000011

            CMP     R1, #2_0010                                 ; Tecla B
            IT      EQ
            MOVEQ   R1, #2_01000010

            CMP     R1, #2_0001                                 ; Tecla A
            IT      EQ
            MOVEQ   R1, #2_01000001

            B       teclado_retorno

teclado_retorno
            LDR     R0, =TECLADO_PRESS_ADDR                     ; Sinala que um botão foi clicado
            MOV     R2, #1
            STR     R2, [R0]

            BX      LR       ; Retorno

            ALIGN                        ;Garante que o fim da secao esta alinhada 
            END                          ;Fim do arquivo