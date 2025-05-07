; gpio.s
; Desenvolvido para a placa EK-TM4C129EXL
; Prof. Guilherme Peron
; 24/08/2020

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports

; PORT A
GPIO_PORTA_AHB_LOCK_R		EQU		0x40058520
GPIO_PORTA_AHB_CR_R			EQU		0x40058524
GPIO_PORTA_AHB_AMSEL_R		EQU		0x40058528
GPIO_PORTA_AHB_PCTL_R		EQU		0x4005852C
GPIO_PORTA_AHB_DIR_R		EQU		0x40058400
GPIO_PORTA_AHB_AFSEL_R		EQU		0x40058420
GPIO_PORTA_AHB_DEN_R		EQU		0x4005851C
GPIO_PORTA_AHB_PUR_R		EQU		0x40058510
GPIO_PORTA_AHB_DATA_R		EQU		0x400583FC
GPIO_PORTA               	EQU		2_000000000000001

; PORT B
GPIO_PORTB_AHB_LOCK_R		EQU		0x40059520
GPIO_PORTB_AHB_CR_R			EQU		0x40059524
GPIO_PORTB_AHB_AMSEL_R		EQU		0x40059528
GPIO_PORTB_AHB_PCTL_R		EQU		0x4005952C
GPIO_PORTB_AHB_DIR_R		EQU		0x40059400
GPIO_PORTB_AHB_AFSEL_R		EQU		0x40059420
GPIO_PORTB_AHB_DEN_R		EQU		0x4005951C
GPIO_PORTB_AHB_PUR_R		EQU		0x40059510
GPIO_PORTB_AHB_DATA_R		EQU		0x400593FC
GPIO_PORTB               	EQU		2_000000000000010

; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ_AHB_DATA_BITS_R  EQU    0x40060000
GPIO_PORTJ_AHB_RIS_R        EQU    0x40060414
GPIO_PORTJ_AHB_ICR_R        EQU    0x4006041C
GPIO_PORTJ_AHB_IS_R			EQU	   0x40060404
GPIO_PORTJ_AHB_IBE_R		EQU	   0x40060408
GPIO_PORTJ_AHB_IEV_R		EQU	   0x4006040C
GPIO_PORTJ_AHB_IM_R			EQU    0x40060410
GPIO_PORTJ               	EQU    2_000000100000000

; PORT K
GPIO_PORTK_LOCK_R       	EQU	    0x40061520
GPIO_PORTK_CR_R         	EQU	    0x40061524
GPIO_PORTK_AMSEL_R      	EQU     0x40061528
GPIO_PORTK_PCTL_R       	EQU     0x4006152C
GPIO_PORTK_DIR_R        	EQU     0x40061400
GPIO_PORTK_AFSEL_R      	EQU     0x40061420
GPIO_PORTK_DEN_R        	EQU     0x4006151C
GPIO_PORTK_PUR_R        	EQU     0x40061510
GPIO_PORTK_DATA_R       	EQU     0x400613FC
GPIO_PORTK               	EQU     2_000001000000000

; PORT M
GPIO_PORTM_LOCK_R           EQU     0x40063520
GPIO_PORTM_CR_R             EQU     0x40063524
GPIO_PORTM_AMSEL_R          EQU     0x40063528
GPIO_PORTM_PCTL_R           EQU     0x4006352C
GPIO_PORTM_DIR_R            EQU     0x40063400
GPIO_PORTM_AFSEL_R          EQU     0x40063420
GPIO_PORTM_DEN_R            EQU     0x4006351C
GPIO_PORTM_PUR_R            EQU     0x40063510
GPIO_PORTM_DATA_R           EQU     0x400633FC
GPIO_PORTM               	EQU     2_000100000000000	

; PORT Q
GPIO_PORTQ_LOCK_R			EQU		0x40066520
GPIO_PORTQ_CR_R				EQU		0x40066524
GPIO_PORTQ_AMSEL_R			EQU		0x40066528
GPIO_PORTQ_PCTL_R			EQU		0x4006652C
GPIO_PORTQ_DIR_R			EQU		0x40066400
GPIO_PORTQ_AFSEL_R			EQU		0x40066420
GPIO_PORTQ_DEN_R			EQU		0x4006651C
GPIO_PORTQ_PUR_R			EQU		0x40066510
GPIO_PORTQ_DATA_R			EQU		0x400663FC
GPIO_PORTQ               	EQU		2_100000000000000

NVIC_EN1_R			  		EQU 0xE000E104
NVIC_PRI12_R		  		EQU 0xE000E430
	
; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2
		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
        EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
        EXPORT PortB_Output			; Permite chamar PortB_Output de outro arquivo
        EXPORT PortK_Output			; Permite chamar PortK_Output de outro arquivo
		EXPORT PortM_Output			; Permite chamar PortM_Output de outro arquivo
		EXPORT PortQ_Output         ; Permite chamar PortQ_Output de outro arquivo
		IMPORT  SysTick_Wait1ms
;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            PUSH    {R0, R1, R2, LR}		        ; Salva os registradores que serão usados na pilha
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTA                 ; Ativa o clock para a porta A
            ORR     R1, #GPIO_PORTB                 ; Ativa o clock para a porta B
            ORR     R1, #GPIO_PORTJ                 ; Ativa o clock para a porta J
            ORR     R1, #GPIO_PORTK                 ; Ativa o clock para a porta K
            ORR     R1, #GPIO_PORTM                 ; Ativa o clock para a porta M
            ORR     R1, #GPIO_PORTQ                 ; Ativa o clock para a porta Q
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV     R2, #GPIO_PORTA                 ; Configura os bits para verificar a porta A
            ORR     R2, #GPIO_PORTB                 ; Configura os bits para verificar a porta B
            ORR     R2, #GPIO_PORTJ                 ; Configura os bits para verificar a porta J
            ORR     R2, #GPIO_PORTK                 ; Configura os bits para verificar a porta K
            ORR     R2, #GPIO_PORTM                 ; Configura os bits para verificar a porta M
            ORR     R2, #GPIO_PORTQ                 ; Configura os bits para verificar a porta Q
            TST     R1, R2							;Testa o R1 com R2 fazendo R1 & R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
            LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ; Endereço do AMSEL para a porta A
            STR     R1, [R0]                        ; Escreve no registrador AMSEL
            LDR     R0, =GPIO_PORTB_AHB_AMSEL_R     ; Endereço do AMSEL para a porta B
            STR     R1, [R0]                        ; Escreve no registrador AMSEL
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ; Endereço do AMSEL para a porta J
            STR     R1, [R0]                        ; Escreve no registrador AMSEL
            LDR     R0, =GPIO_PORTK_AMSEL_R         ; Endereço do AMSEL para a porta K
            STR     R1, [R0]                        ; Escreve no registrador AMSEL
            LDR     R0, =GPIO_PORTM_AMSEL_R         ; Endereço do AMSEL para a porta M
            STR     R1, [R0]                        ; Escreve no registrador AMSEL
            LDR     R0, =GPIO_PORTQ_AMSEL_R         ; Endereço do AMSEL para a porta Q
            STR     R1, [R0]                        ; Escreve no registrador AMSEL    
 
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00                       ; Configura 0 para selecionar GPIO
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ; Endereço do PCTL para a porta A
            STR     R1, [R0]                        ; Escreve no registrador PCTL
            LDR     R0, =GPIO_PORTB_AHB_PCTL_R      ; Endereço do PCTL para a porta B
            STR     R1, [R0]                        ; Escreve no registrador PCTL
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R      ; Endereço do PCTL para a porta J
            STR     R1, [R0]                        ; Escreve no registrador PCTL
            LDR     R0, =GPIO_PORTK_PCTL_R          ; Endereço do PCTL para a porta K
            STR     R1, [R0]                        ; Escreve no registrador PCTL
            LDR     R0, =GPIO_PORTM_PCTL_R          ; Endereço do PCTL para a porta M
            STR     R1, [R0]                        ; Escreve no registrador PCTL
            LDR     R0, =GPIO_PORTQ_PCTL_R          ; Endereço do PCTL para a porta Q
            STR     R1, [R0]                        ; Escreve no registrador PCTL

; 4. DIR para 0 se for entrada, 1 se for sa�da
            ; Configura PA7:PA4 como saída (displays de 7 segmentos)
            LDR     R0, =GPIO_PORTA_AHB_DIR_R       ; Endereço do DIR para a porta A
            MOV     R1, #0xF0                       ; PA7:PA4 como saída
            STR     R1, [R0]                        ; Escreve no registrador DIR

            ; Configura PB5 e PB4 como saída (transistores)
            LDR     R0, =GPIO_PORTB_AHB_DIR_R       ; Endereço do DIR para a porta B
            MOV     R1, #0x30                       ; PB5 e PB4 como saída
            STR     R1, [R0]                        ; Escreve no registrador DIR

            ; Configura PJ0 e PJ1 como entrada (botões USR_SW1 e USR_SW2)
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R       ; Endereço do DIR para a porta J
            MOV     R1, #0x00                       ; PJ0 e PJ1 como entrada
            STR     R1, [R0]                        ; Escreve no registrador DIR

            ; Configura PK7:PK0 como saída (LCD)
            LDR     R0, =GPIO_PORTK_DIR_R           ; Endereço do DIR para a porta K
            MOV     R1, #0xFF                       ; Configura PK7–PK0 como saída
            STR     R1, [R0]                        ; Escreve no registrador DIR

            ; Configura PM2:PM0 como saída (LCD)
            LDR     R0, =GPIO_PORTM_DIR_R           ; Endereço do DIR para a porta M
            MOV     R1, #0x07                       ; Configura PM2–PM0 como saída
            STR     R1, [R0]                        ; Escreve no registrador DIR

                        ; Configura PQ3:PQ0 como saída (displays de 7 segmentos)
            LDR     R0, =GPIO_PORTQ_DIR_R           ; Endereço do DIR para a porta Q
            MOV     R1, #0x0F                       ; PQ3:PQ0 como saída
            STR     R1, [R0]                        ; Escreve no registrador DIR

            
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00                       ; Configura 0 para desabilitar função alternativa
            LDR     R0, =GPIO_PORTA_AHB_AFSEL_R     ; Endereço do AFSEL para a porta A
            STR     R1, [R0]                        ; Escreve no registrador AFSEL
            LDR     R0, =GPIO_PORTB_AHB_AFSEL_R     ; Endereço do AFSEL para a porta B
            STR     R1, [R0]                        ; Escreve no registrador AFSEL
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ; Endereço do AFSEL para a porta J
            STR     R1, [R0]                        ; Escreve no registrador AFSEL
            LDR     R0, =GPIO_PORTK_AFSEL_R         ; Endereço do AFSEL para a porta K
            STR     R1, [R0]                        ; Escreve no registrador AFSEL
            LDR     R0, =GPIO_PORTM_AFSEL_R         ; Endereço do AFSEL para a porta M
            STR     R1, [R0]                        ; Escreve no registrador AFSEL
            LDR     R0, =GPIO_PORTQ_AFSEL_R         ; Endereço do AFSEL para a porta Q
            STR     R1, [R0]                        ; Escreve no registrador AFSEL

; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTA_AHB_DEN_R       ; Endereço do DEN para a porta A
            MOV     R1, #0xF0                       ; Habilita PA7:PA4 como digital
            STR     R1, [R0]                        ; Escreve no registrador DEN

            LDR     R0, =GPIO_PORTB_AHB_DEN_R       ; Endereço do DEN para a porta B
            MOV     R1, #0x30                       ; Habilita PB5 e PB4 como digital
            STR     R1, [R0]                        ; Escreve no registrador DEN

            LDR     R0, =GPIO_PORTJ_AHB_DEN_R       ; Endereço do DEN para a porta J
            MOV     R1, #0x03                       ; Habilita PJ0 e PJ1 como digital
            STR     R1, [R0]                        ; Escreve no registrador DEN

            LDR     R0, =GPIO_PORTK_DEN_R           ; Endereço do DEN para a porta K
            MOV     R1, #0xFF                       ; Habilita todos os pinos como digitais (PK7–PK0)
            STR     R1, [R0]                        ; Escreve no registrador DEN

            LDR     R0, =GPIO_PORTM_DEN_R           ; Endereço do DEN para a porta M
            MOV     R1, #0x07                       ; Habilita PM2–PM0 como digitais
            STR     R1, [R0]                        ; Escreve no registrador DEN

            LDR     R0, =GPIO_PORTQ_DEN_R           ; Endereço do DEN para a porta Q
            MOV     R1, #0x0F                       ; Habilita PQ3:PQ0 como digital
            STR     R1, [R0]                        ; Escreve no registrador DEN
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R       ; Endereço do PUR para a porta J
            MOV     R1, #0x03                       ; Habilita resistores de pull-up para PJ0 e PJ1
            STR     R1, [R0]                        ; Escreve no registrador PUR

            POP     {R0, R1, R2, LR}                ; Restaura os registradores usados da pilha
			BX      LR                              ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortA_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PA7:PA4
; Parâmetro de saída: Nenhum
PortA_Output
    PUSH    {R1-R6, LR}
    LDR     R1, =GPIO_PORTA_AHB_DATA_R  ; Carrega o endereço do registrador de dados da porta A
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #0xF0               ; Limpa os bits PA7:PA4 (0b11110000)
    ORR     R2, R2, R0                  ; Define os bits PA7:PA4 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
    POP		{R1-R6, LR}
    BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortB_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PB5:PB4
; Parâmetro de saída: Nenhum
PortB_Output
    PUSH	{R1, R2, LR}
    LDR     R1, =GPIO_PORTB_AHB_DATA_R  ; Carrega o endereço do registrador de dados da porta B
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #0x30               ; Limpa os bits PB5:PB4 (0b00110000)
    ORR     R2, R2, R0                  ; Define os bits PB5:PB4 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
    POP		{R1, R2, LR}
    BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortK_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PQ3:PQ0
; Parâmetro de saída: Nenhum
PortK_Output
	PUSH 	{R1, R2, LR}
    LDR     R1, =GPIO_PORTK_DATA_R      ; Carrega o endereço do registrador de dados da porta K
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #0xFF               ; Limpa os bits PK7:PK0 (0b11111111)
    ORR     R2, R2, R0                  ; Define os bits PK7:PK0 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
    POP     {R1, R2, LR}
	BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortM_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PQ3:PQ0
; Parâmetro de saída: Nenhum
PortM_Output
    PUSH	{R1, R2, LR}
    LDR     R1, =GPIO_PORTM_DATA_R      ; Carrega o endereço do registrador de dados da porta M
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #0x07               ; Limpa os bits PM2:PM0 (0b00000111)
    ORR     R2, R2, R0                  ; Define os bits PM2:PM0 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
	POP		{R1, R2, LR}
	BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortQ_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PQ3:PQ0
; Parâmetro de saída: Nenhum
PortQ_Output
    PUSH    {R1-R6, LR}
    LDR     R1, =GPIO_PORTQ_DATA_R      ; Carrega o endereço do registrador de dados da porta Q
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #0x0F               ; Limpa os bits PQ3:PQ0 (0b00001111)
    ORR     R2, R2, R0                  ; Define os bits PQ3:PQ0 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
    POP		{R1-R6, LR}
    BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função GPIOPortJ_Init
; Configura PJ0 e PJ1 como pinos de interrupção
GPIOPortJ_Init
    PUSH {R0, R1, R2, R3, LR}
    ; Configura o registrador de máscara de interrupção (IM) para a porta J
    LDR R2, =GPIO_PORTJ_AHB_IM_R        ; Carrega o endereço do registrador IM da porta J
    LDR R1, [R2]                        ; Lê o valor do registrador IM
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_00                   ; Desabilitar todas as interrupções em J0 e J1
    STR R1, [R2]                        ; Escreve o valor no registrador IM

    ; Configura o registrador de detecção de borda (IS) para a porta J
    LDR R0, =GPIO_PORTJ_AHB_IS_R        ; Carrega o endereço do registrador IS da porta J
    LDR R1, [R0]                        ; Lê o valor do registrador IS
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_00                   ; Detecção de borda (0 = detecção de borda)
    STR R1, [R0]                        ; Escreve o valor no registrador IS (0 = detecção de borda)

    ; Configura o registrador de detecção de borda dupla (IBE) para a porta J
    LDR R0, =GPIO_PORTJ_AHB_IBE_R       ; Carrega o endereço do registrador IBE da porta J
    LDR R1, [R0]                        ; Lê o valor do registrador IBE
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_00                   ; Borda única (0 = borda única)
    STR R1, [R0]                        ; Escreve o valor no registrador IBE (0 = borda única)

    ; Configura o registrador de evento de borda (IEV) para a porta J
    LDR R0, =GPIO_PORTJ_AHB_IEV_R       ; Carrega o endereço do registrador IEV da porta J
    LDR R1, [R0]                        ; Lê o valor do registrador IEV
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_11                   ; Detecção de borda de subida (1 = borda de subida)
    STR R1, [R0]                        ; Escreve o valor no registrador IEV (1 = borda de subida)

    ; Limpa as interrupções pendentes no registrador ICR
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Carrega o endereço do registrador ICR da porta J
    LDR R1, [R0]                        ; Lê o valor do registrador ICR
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_11                   ; Limpa as interrupções pendentes em J0 e J1 (1 = ACK)
    STR R1, [R0]                        ; Escreve o valor no registrador ICR

    ; Habilita as interrupções no registrador IM
    LDR R1, [R2]                        ; Lê o valor do registrador IM
    BIC R1, R1, #0x03                   ; Limpa os bits correspondentes a J0 e J1 (0b00000011)
    ORR R1, R1, #2_11                   ; Habilita as interrupções em J0 e J1 (1 = habilitado)
    STR R1, [R2]                        ; Escreve o valor no registrador IM

    ; Configura o registrador NVIC para habilitar a interrupção da porta J
    LDR R0, =NVIC_EN1_R                 ; Carrega o endereço do registrador NVIC_EN1
    LDR R1, [R0]                        ; Lê o valor do registrador NVIC_EN1
    MOV R2, #2_1                        ; Define o bit correspondente à interrupção da porta J
    LSL R2, #19                         ; Desloca o valor para a posição correta
    BIC R1, R1, R2                      ; Limpa o bit correspondente à interrupção da porta J
    ORR R1, R1, R2                      ; Habilita a interrupção da porta J
    STR R1, [R0]                        ; Escreve o valor no registrador NVIC_EN1

    ; Configura a prioridade da interrupção no registrador NVIC_PRI12
    LDR R0, =NVIC_PRI12_R               ; Carrega o endereço do registrador NVIC_PRI12
    LDR R1, [R0]                        ; Lê o valor do registrador NVIC_PRI12
    MOV R3, #0x07                       ; Define o valor para a prioridade da interrupção
    LSL R3, #29                         ; Desloca o valor para a posição correta
    BIC R1, R1, R3                      ; Limpa os bits correspondentes à prioridade da interrupção
    MOV R2, #5                          ; Define a prioridade da interrupção
    LSL R2, #29                         ; Desloca o valor para a posição correta
    ORR R1, R1, R2                      ; Habilita a prioridade da interrupção
    STR R1, [R0]                        ; Escreve o valor no registrador NVIC_PRI12

    ; Retorna da função
    POP {R0, R1, R2, R3, LR}            ; Restaura os registradores da pilha
    BX LR                               ; Retorna para o chamador

; -------------------------------------------------------------------------------
; Função GPIOPortQ_Init
; Configura PJ0 e PJ1 como pinos de interrupção
GPIOPortQ_Init
    PUSH {R0, R1, R2, R3, R4, R5, R6, R7, LR}
    BX LR                               ; Retorna para o chamador


; -------------------------------------------------------------------------------
; Função GPIOPortJ_Handler
; Gerencia interrupções em PJ0 e PJ1, limpando flags
GPIOPortJ_Handler
    PUSH {LR}                           ; Salva o registrador LR na pilha
    LDR R0, =GPIO_PORTJ_AHB_RIS_R       ; Carrega o endereço do registrador RIS da porta J
    LDR R1, [R0]                        ; Lê o valor do registrador RIS
VerificaJ0  
    CMP R1, #2_01                       ; Compara o valor com o bit correspondente a J0
    BNE VerificaJ1                      ; Se não for igual, vai para VerificaJ1
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Carrega o endereço do registrador ICR da porta J
	ADD R5, R5, #1
	CMP R5, #10
	IT GE
    SUBGE R5, R5, #9
    MOV R1, #2_01                       ; Define o valor para limpar a interrupção de J0
    STR R1, [R0]                        ; Escreve no registrador ICR
    B   Fim_Ver                         ; Salta para o final
VerificaJ1  
    CMP R1, #2_10                       ; Compara o valor com o bit correspondente a J1
    BNE VerificaAmbos                   ; Se não for igual, vai para VerificaAmbos
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Carrega o endereço do registrador ICR da porta J
	CMP R6, #0
	ITE EQ
	MOVEQ R6, #1                        ; Se R6 = 0, muda o modo para 1
	MOVNE R6, #0                        ; Se R6 = 1, muda o modo para 0
    MOV R1, #2_10                       ; Define o valor para limpar a interrupção de J1
    STR R1, [R0]                        ; Escreve no registrador ICR
    B   Fim_Ver                         ; Salta para o final
VerificaAmbos
    CMP R1, #2_11                       ; Compara o valor com os bits correspondentes a J0 e J1
    BNE Fim_Ver                         ; Se não for igual, vai para o final
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Carrega o endereço do registrador ICR da porta J
    MOV R1, #2_11                       ; Define o valor para limpar as interrupções de J0 e J1
    STR R1, [R0]                        ; Escreve no registrador ICR
Fim_Ver
    POP {LR}                            ; Restaura o registrador LR da pilha
    BX LR                               ; Retorna para o chamador

    ALIGN                               ; garante que o fim da se��o est� alinhada 
    END                                 ; fim do arquivo
