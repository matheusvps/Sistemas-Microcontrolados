; matricial.s
; Desenvolvido para a placa EK-TM4C1294XL
; Matheus Passos, Lucas Yukio, João Castilho

; -------------------------------------------------------------------------------
    THUMB                        ; Instrucoes do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declaracoes EQU - Defines
; ========================
; ========================
; Definicoes dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definicoes dos Ports
; ~~~~~~~~~~~~~~~~ PORT A ~~~~~~~~~~~~~~~~~~
GPIO_PORTA_AHB_LOCK_R 		EQU     0x40058520
GPIO_PORTA_AHB_CR_R     	EQU     0x40058524
GPIO_PORTA_AHB_AMSEL_R  	EQU	    0x40058528
GPIO_PORTA_AHB_PCTL_R   	EQU	    0x4005852C
GPIO_PORTA_AHB_DIR_R    	EQU	    0x40058400
GPIO_PORTA_AHB_AFSEL_R  	EQU	    0x40058420
GPIO_PORTA_AHB_DEN_R    	EQU     0x4005851C
GPIO_PORTA_AHB_PUR_R    	EQU     0x40058510
GPIO_PORTA_AHB_DATA_R   	EQU     0x400583FC
GPIO_PORTA 					EQU     2_000000000000001

; ~~~~~~~~~~~~~~~~ PORT B ~~~~~~~~~~~~~~~~~~
GPIO_PORTB_AHB_DATA_R   	EQU     0x400593FC
GPIO_PORTB_AHB_DIR_R    	EQU     0x40059400
GPIO_PORTB_AHB_AFSEL_R  	EQU     0x40059420
GPIO_PORTB_AHB_PUR_R    	EQU     0x40059510
GPIO_PORTB_AHB_DEN_R    	EQU     0x4005951C
GPIO_PORTB_AHB_LOCK_R   	EQU     0x40059520
GPIO_PORTB_AHB_CR_R     	EQU     0x40059524
GPIO_PORTB_AHB_AMSEL_R  	EQU     0x40059528
GPIO_PORTB_AHB_PCTL_R   	EQU     0x4005952C
GPIO_PORTB 					EQU     2_000000000000010

; ~~~~~~~~~~~~~~~~ PORT C ~~~~~~~~~~~~~~~~~~
GPIO_PORTC_AHB_DATA_R   	EQU     0x4005A3FC
GPIO_PORTC_AHB_DIR_R    	EQU     0x4005A400
GPIO_PORTC_AHB_AFSEL_R  	EQU     0x4005A420
GPIO_PORTC_AHB_PUR_R    	EQU     0x4005A510
GPIO_PORTC_AHB_DEN_R    	EQU     0x4005A51C
GPIO_PORTC_AHB_LOCK_R   	EQU     0x4005A520
GPIO_PORTC_AHB_CR_R     	EQU     0x4005A524
GPIO_PORTC_AHB_AMSEL_R  	EQU     0x4005A528
GPIO_PORTC_AHB_PCTL_R   	EQU     0x4005A52C
GPIO_PORTC 					EQU     2_000000000000100

; ~~~~~~~~~~~~~~~~ PORT D ~~~~~~~~~~~~~~~~~~
GPIO_PORTD_AHB_DATA_R   	EQU     0x4005B3FC
GPIO_PORTD_AHB_DIR_R    	EQU     0x4005B400
GPIO_PORTD_AHB_AFSEL_R  	EQU     0x4005B420
GPIO_PORTD_AHB_PUR_R    	EQU     0x4005B510
GPIO_PORTD_AHB_DEN_R    	EQU     0x4005B51C
GPIO_PORTD_AHB_LOCK_R   	EQU     0x4005B520
GPIO_PORTD_AHB_CR_R     	EQU     0x4005B524
GPIO_PORTD_AHB_AMSEL_R  	EQU     0x4005B528
GPIO_PORTD_AHB_PCTL_R   	EQU     0x4005B52C
GPIO_PORTD 					EQU     2_000000000001000

; ~~~~~~~~~~~~~~~~ PORT E ~~~~~~~~~~~~~~~~~~
GPIO_PORTE_AHB_DATA_R   	EQU     0x4005C3FC
GPIO_PORTE_AHB_DIR_R    	EQU     0x4005C400
GPIO_PORTE_AHB_AFSEL_R  	EQU     0x4005C420
GPIO_PORTE_AHB_PUR_R    	EQU     0x4005C510
GPIO_PORTE_AHB_DEN_R    	EQU     0x4005C51C
GPIO_PORTE_AHB_LOCK_R   	EQU     0x4005C520
GPIO_PORTE_AHB_CR_R     	EQU     0x4005C524
GPIO_PORTE_AHB_AMSEL_R  	EQU     0x4005C528
GPIO_PORTE_AHB_PCTL_R   	EQU     0x4005C52C
GPIO_PORTE 					EQU     2_000000000010000

; ~~~~~~~~~~~~~~~~ PORT F ~~~~~~~~~~~~~~~~~~
GPIO_PORTF_AHB_DATA_R   	EQU     0x4005D3FC
GPIO_PORTF_AHB_DIR_R    	EQU     0x4005D400
GPIO_PORTF_AHB_AFSEL_R  	EQU     0x4005D420
GPIO_PORTF_AHB_PUR_R    	EQU     0x4005D510
GPIO_PORTF_AHB_DEN_R    	EQU     0x4005D51C
GPIO_PORTF_AHB_LOCK_R   	EQU     0x4005D520
GPIO_PORTF_AHB_CR_R     	EQU     0x4005D524
GPIO_PORTF_AHB_AMSEL_R  	EQU     0x4005D528
GPIO_PORTF_AHB_PCTL_R   	EQU     0x4005D52C
GPIO_PORTF 			EQU     2_000000000100000

; ~~~~~~~~~~~~~~~~ PORT G ~~~~~~~~~~~~~~~~~~
GPIO_PORTG_AHB_DATA_R   	EQU     0x4005E3FC
GPIO_PORTG_AHB_DIR_R    	EQU     0x4005E400
GPIO_PORTG_AHB_AFSEL_R  	EQU     0x4005E420
GPIO_PORTG_AHB_PUR_R    	EQU     0x4005E510
GPIO_PORTG_AHB_DEN_R    	EQU     0x4005E51C
GPIO_PORTG_AHB_LOCK_R   	EQU     0x4005E520
GPIO_PORTG_AHB_CR_R     	EQU     0x4005E524
GPIO_PORTG_AHB_AMSEL_R  	EQU     0x4005E528
GPIO_PORTG_AHB_PCTL_R   	EQU     0x4005E52C
GPIO_PORTG 					EQU     2_000000001000000

; ~~~~~~~~~~~~~~~~ PORT H ~~~~~~~~~~~~~~~~~~
GPIO_PORTH_AHB_DATA_R   	EQU     0x4005F3FC
GPIO_PORTH_AHB_DIR_R    	EQU     0x4005F400
GPIO_PORTH_AHB_AFSEL_R  	EQU     0x4005F420
GPIO_PORTH_AHB_PUR_R    	EQU     0x4005F510
GPIO_PORTH_AHB_DEN_R    	EQU     0x4005F51C
GPIO_PORTH_AHB_LOCK_R   	EQU     0x4005F520
GPIO_PORTH_AHB_CR_R     	EQU     0x4005F524
GPIO_PORTH_AHB_AMSEL_R  	EQU     0x4005F528
GPIO_PORTH_AHB_PCTL_R   	EQU     0x4005F52C
GPIO_PORTH 					EQU     2_000000010000000

; ~~~~~~~~~~~~~~~~ PORT J ~~~~~~~~~~~~~~~~~~
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510
GPIO_PORTJ_AHB_DEN_R        EQU    0x4006051C
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ               	EQU    2_000000100000000

; ~~~~~~~~~~~~~~~~ PORT K ~~~~~~~~~~~~~~~~~~
GPIO_PORTK_DATA_R           EQU     0x400613FC
GPIO_PORTK_DIR_R            EQU     0x40061400
GPIO_PORTK_AFSEL_R          EQU     0x40061420
GPIO_PORTK_PUR_R            EQU     0x40061510
GPIO_PORTK_DEN_R            EQU     0x4006151C
GPIO_PORTK_LOCK_R           EQU     0x40061520
GPIO_PORTK_CR_R             EQU     0x40061524
GPIO_PORTK_AMSEL_R          EQU     0x40061528
GPIO_PORTK_PCTL_R           EQU     0x4006152C
GPIO_PORTK               	EQU     2_000001000000000

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
GPIO_PORTL               	EQU     2_000010000000000

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
GPIO_PORTM               	EQU     2_000100000000000

; ~~~~~~~~~~~~~~~~ PORT N ~~~~~~~~~~~~~~~~~~
GPIO_PORTN_DATA_R           EQU     0x400643FC
GPIO_PORTN_DIR_R            EQU     0x40064400
GPIO_PORTN_AFSEL_R          EQU     0x40064420
GPIO_PORTN_PUR_R            EQU     0x40064510
GPIO_PORTN_DEN_R            EQU     0x4006451C
GPIO_PORTN_LOCK_R           EQU     0x40064520
GPIO_PORTN_CR_R             EQU     0x40064524
GPIO_PORTN_AMSEL_R          EQU     0x40064528
GPIO_PORTN_PCTL_R           EQU     0x4006452C
GPIO_PORTN               	EQU     2_001000000000000

; ~~~~~~~~~~~~~~~~ PORT P ~~~~~~~~~~~~~~~~~~
GPIO_PORTP_DATA_R           EQU     0x400653FC
GPIO_PORTP_DIR_R            EQU     0x40065400
GPIO_PORTP_AFSEL_R          EQU     0x40065420
GPIO_PORTP_PUR_R            EQU     0x40065510
GPIO_PORTP_DEN_R            EQU     0x4006551C
GPIO_PORTP_LOCK_R           EQU     0x40065520
GPIO_PORTP_CR_R             EQU     0x40065524
GPIO_PORTP_AMSEL_R          EQU     0x40065528
GPIO_PORTP_PCTL_R           EQU     0x4006552C
GPIO_PORTP               	EQU     2_010000000000000

; ~~~~~~~~~~~~~~~~ PORT Q ~~~~~~~~~~~~~~~~~~
GPIO_PORTQ_DATA_R           EQU     0x400663FC
GPIO_PORTQ_DIR_R            EQU     0x40066400
GPIO_PORTQ_AFSEL_R          EQU     0x40066420
GPIO_PORTQ_PUR_R            EQU     0x40066510
GPIO_PORTQ_DEN_R            EQU     0x4006651C
GPIO_PORTQ_LOCK_R           EQU     0x40066520
GPIO_PORTQ_CR_R             EQU     0x40066524
GPIO_PORTQ_AMSEL_R          EQU     0x40066528
GPIO_PORTQ_PCTL_R           EQU     0x4006652C
GPIO_PORTQ               	EQU     2_100000000000000
TECLADO_PRESS_ADDR          EQU     0x20000B00

; ===========================================
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