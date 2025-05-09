; gpio.s
; Desenvolvido para a placa EK-TM4C129EXL
; Matheus Passos, Lucas Yukio, João Castilho Cardoso

; -------------------------------------------------------------------------------
    THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports

; PORT A
GPIO_PORTA_AHB_AMSEL_R		EQU		0x40058528
GPIO_PORTA_AHB_PCTL_R		EQU		0x4005852C
GPIO_PORTA_AHB_DIR_R		EQU		0x40058400
GPIO_PORTA_AHB_AFSEL_R		EQU		0x40058420
GPIO_PORTA_AHB_DEN_R		EQU		0x4005851C
GPIO_PORTA_AHB_DATA_R		EQU		0x400583FC
GPIO_PORTA               	EQU		2_000000000000001

; PORT B
GPIO_PORTB_AHB_AMSEL_R		EQU		0x40059528
GPIO_PORTB_AHB_PCTL_R		EQU		0x4005952C
GPIO_PORTB_AHB_DIR_R		EQU		0x40059400
GPIO_PORTB_AHB_AFSEL_R		EQU		0x40059420
GPIO_PORTB_AHB_DEN_R		EQU		0x4005951C
GPIO_PORTB_AHB_PUR_R		EQU		0x40059510
GPIO_PORTB_AHB_DATA_R		EQU		0x400593FC
GPIO_PORTB               	EQU		2_000000000000010

; PORT J
GPIO_PORTJ_AHB_AMSEL_R   	EQU     0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU     0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU     0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU     0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU     0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU     0x40060510
GPIO_PORTJ_AHB_RIS_R        EQU     0x40060414
GPIO_PORTJ_AHB_ICR_R        EQU     0x4006041C
GPIO_PORTJ_AHB_IS_R         EQU     0x40060404
GPIO_PORTJ_AHB_IBE_R        EQU     0x40060408
GPIO_PORTJ_AHB_IEV_R        EQU     0x4006040C
GPIO_PORTJ_AHB_IM_R         EQU     0x40060410
GPIO_PORTJ               	EQU     2_000000100000000

; PORT K
GPIO_PORTK_AMSEL_R      	EQU     0x40061528
GPIO_PORTK_PCTL_R       	EQU     0x4006152C
GPIO_PORTK_DIR_R        	EQU     0x40061400
GPIO_PORTK_AFSEL_R      	EQU     0x40061420
GPIO_PORTK_DEN_R        	EQU     0x4006151C
GPIO_PORTK_DATA_R       	EQU     0x400613FC
GPIO_PORTK               	EQU     2_000001000000000

; PORT M
GPIO_PORTM_AMSEL_R          EQU     0x40063528
GPIO_PORTM_PCTL_R           EQU     0x4006352C
GPIO_PORTM_DIR_R            EQU     0x40063400
GPIO_PORTM_AFSEL_R          EQU     0x40063420
GPIO_PORTM_DEN_R            EQU     0x4006351C
GPIO_PORTM_DATA_R           EQU     0x400633FC
GPIO_PORTM               	EQU     2_000100000000000

; PORT Q
GPIO_PORTQ_AMSEL_R			EQU		0x40066528
GPIO_PORTQ_PCTL_R			EQU		0x4006652C
GPIO_PORTQ_DIR_R			EQU		0x40066400
GPIO_PORTQ_AFSEL_R			EQU		0x40066420
GPIO_PORTQ_DEN_R			EQU		0x4006651C
GPIO_PORTQ_DATA_R			EQU		0x400663FC
GPIO_PORTQ               	EQU		2_100000000000000

; NVIC
NVIC_EN1_R			  		EQU 0xE000E104
NVIC_PRI12_R		  		EQU 0xE000E430

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
    AREA |.text|, CODE, READONLY, ALIGN=2
    ; Se alguma função do arquivo for chamada em outro arquivo
    EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
    EXPORT PortA_Output			; Permite chamar PortA_Output de outro arquivo
    EXPORT PortB_Output			; Permite chamar PortB_Output de outro arquivo
    EXPORT PortK_Output			; Permite chamar PortK_Output de outro arquivo
    EXPORT PortM_Output			; Permite chamar PortM_Output de outro arquivo
    EXPORT PortQ_Output         ; Permite chamar PortQ_Output de outro arquivo
    EXPORT GPIOPortJ_Init       ; Permite chamar GPIO_PortJ_Init de outro arquivo
    EXPORT GPIOPortJ_Handler    ; Permite acesso do sistem ao GPIOPortJ_Handler

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
    PUSH    {R0, R1, R2, LR}		    ; Salva os registradores que serão usados na pilha
    LDR     R0, =SYSCTL_RCGCGPIO_R      ; Carrega o endereço do registrador RCGCGPIO
    MOV		R1, #GPIO_PORTA             ; Ativa o clock para a porta A
    ORR     R1, #GPIO_PORTB             ; Ativa o clock para a porta B
    ORR     R1, #GPIO_PORTJ             ; Ativa o clock para a porta J
    ORR     R1, #GPIO_PORTK             ; Ativa o clock para a porta K
    ORR     R1, #GPIO_PORTM             ; Ativa o clock para a porta M
    ORR     R1, #GPIO_PORTQ             ; Ativa o clock para a porta Q
    STR     R1, [R0]				    ; Move para a memória os bits das portas no endereço do RCGCGPIO

    LDR     R0, =SYSCTL_PRGPIO_R	    ; Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO
    LDR     R1, [R0]				    ; Lê da memória o conteúdo do endereço do registrador
    MOV     R2, #GPIO_PORTA             ; Configura os bits para verificar a porta A
    ORR     R2, #GPIO_PORTB             ; Configura os bits para verificar a porta B
    ORR     R2, #GPIO_PORTJ             ; Configura os bits para verificar a porta J
    ORR     R2, #GPIO_PORTK             ; Configura os bits para verificar a porta K
    ORR     R2, #GPIO_PORTM             ; Configura os bits para verificar a porta M
    ORR     R2, #GPIO_PORTQ             ; Configura os bits para verificar a porta Q
    TST     R1, R2					    ; Testa o R1 com R2 fazendo R1 & R2
    BEQ     EsperaGPIO				    ; Se o flag Z=1, volta para o laço. Senão continua executando

; 2. Limpar o AMSEL para desabilitar a analógica
    MOV     R1, #0x00						; Colocar 0 no registrador para desabilitar a função analógica
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

; 4. DIR para 0 se for entrada, 1 se for saída
    ; Configura PA7:PA4 como saída (displays de 7 segmentos)
    LDR     R0, =GPIO_PORTA_AHB_DIR_R       ; Endereço do DIR para a porta A
    MOV     R1, #2_11110000                 ; PA7:PA4 como saída
    STR     R1, [R0]                        ; Escreve no registrador DIR

    ; Configura PB5 e PB4 como saída (transistores)
    LDR     R0, =GPIO_PORTB_AHB_DIR_R       ; Endereço do DIR para a porta B
    MOV     R1, #2_00110000                 ; PB5 e PB4 como saída
    STR     R1, [R0]                        ; Escreve no registrador DIR

    ; Configura PJ0 e PJ1 como entrada (botões USR_SW1 e USR_SW2)
    LDR     R0, =GPIO_PORTJ_AHB_DIR_R       ; Endereço do DIR para a porta J
    MOV     R1, #0x00000000                 ; PJ0 e PJ1 como entrada
    STR     R1, [R0]                        ; Escreve no registrador DIR

    ; Configura PK7:PK0 como saída (LCD)
    LDR     R0, =GPIO_PORTK_DIR_R           ; Endereço do DIR para a porta K
    MOV     R1, #2_11111111                 ; Configura PK7–PK0 como saída
    STR     R1, [R0]                        ; Escreve no registrador DIR

    ; Configura PM2:PM0 como saída (LCD)
    LDR     R0, =GPIO_PORTM_DIR_R           ; Endereço do DIR para a porta M
    MOV     R1, #2_00000111                 ; Configura PM2–PM0 como saída
    STR     R1, [R0]                        ; Escreve no registrador DIR

    ; Configura PQ3:PQ0 como saída (displays de 7 segmentos)
    LDR     R0, =GPIO_PORTQ_DIR_R           ; Endereço do DIR para a porta Q
    MOV     R1, #2_00001111                 ; PQ3:PQ0 como saída
    STR     R1, [R0]                        ; Escreve no registrador DIR

; 5. Limpar os bits AFSEL para 0 para selecionar GPIO
;    Sem função alternativa
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
    MOV     R1, #2_11110000                 ; Habilita PA7:PA4 como digital
    STR     R1, [R0]                        ; Escreve no registrador DEN

    LDR     R0, =GPIO_PORTB_AHB_DEN_R       ; Endereço do DEN para a porta B
    MOV     R1, #2_00110000                 ; Habilita PB5 e PB4 como digital
    STR     R1, [R0]                        ; Escreve no registrador DEN

    LDR   R0, =GPIO_PORTJ_AHB_DEN_R         ; Endereço do DEN para a porta J
    MOV   R1, #0x03                         ; Bits 1:0 = 1, habilita PJ0 e PJ1 como digitais
    STR   R1, [R0]                          ; Escreve no registrador DEN

    LDR     R0, =GPIO_PORTK_DEN_R           ; Endereço do DEN para a porta K
    MOV     R1, #2_11111111                 ; Habilita todos os pinos como digitais (PK7–PK0)
    STR     R1, [R0]                        ; Escreve no registrador DEN

    LDR     R0, =GPIO_PORTM_DEN_R           ; Endereço do DEN para a porta M
    MOV     R1, #2_00000111                 ; Habilita PM2–PM0 como digitais
    STR     R1, [R0]                        ; Escreve no registrador DEN

    LDR     R0, =GPIO_PORTQ_DEN_R           ; Endereço do DEN para a porta Q
    MOV     R1, #2_00001111                 ; Habilita PQ3:PQ0 como digital
    STR     R1, [R0]                        ; Escreve no registrador DEN

; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
    LDR   R0, =GPIO_PORTJ_AHB_PUR_R         ; Endereço do PUR para a porta J
    MOV   R1, #0x03                         ; Bits 1:0 = 1 para habilitar os resistores de pull-up
    STR   R1, [R0]                          ; Escreve no registrador PUR

    POP     {R0, R1, R2, LR}                ; Restaura os registradores usados da pilha
    BX      LR                              ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortA_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PA7:PA4
; Parâmetro de saída: Nenhum
PortA_Output
    PUSH    {R1, R2, LR}
    LDR     R1, =GPIO_PORTA_AHB_DATA_R  ; Carrega o endereço do registrador de dados da porta A
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #2_11110000         ; Limpa os bits PA7:PA4 (0b11110000)
    ORR     R2, R2, R0                  ; Define os bits PA7:PA4 com o valor de R0
    STR     R2, [R1]                    ; Escreve o valor atualizado no registrador de dados
    POP		{R1, R2, LR}
    BX      LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortB_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PB5:PB4
; Parâmetro de saída: Nenhum
PortB_Output
    PUSH	{R1, R2, LR}
    LDR     R1, =GPIO_PORTB_AHB_DATA_R  ; Carrega o endereço do registrador de dados da porta B
    LDR     R2, [R1]                    ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #2_00110000         ; Limpa os bits PB5:PB4 (0b00110000)
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
    LDR     R1, =GPIO_PORTK_DATA_R  ; Carrega o endereço do registrador de dados da porta K
    LDR     R2, [R1]                ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #2_11111111     ; Limpa os bits PK7:PK0 (0b11111111)
    ORR     R2, R2, R0              ; Define os bits PK7:PK0 com o valor de R0
    STR     R2, [R1]                ; Escreve o valor atualizado no registrador de dados
    POP     {R1, R2, LR}
    BX      LR                      ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortM_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PQ3:PQ0
; Parâmetro de saída: Nenhum
PortM_Output
    PUSH	{R1, R2, LR}
    LDR     R1, =GPIO_PORTM_DATA_R  ; Carrega o endereço do registrador de dados da porta M
    LDR     R2, [R1]                ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #2_00000111     ; Limpa os bits PM2:PM0 (0b00000111)
    ORR     R2, R2, R0              ; Define os bits PM2:PM0 com o valor de R0
    STR     R2, [R1]                ; Escreve o valor atualizado no registrador de dados
    POP		{R1, R2, LR}
    BX      LR                      ; Retorna da função

; -------------------------------------------------------------------------------
; Função PortQ_Output
; Parâmetro de entrada: R0 --> Valor a ser escrito nos pinos PQ3:PQ0
; Parâmetro de saída: Nenhum
PortQ_Output
    PUSH    {R1, R2, LR}
    LDR     R1, =GPIO_PORTQ_DATA_R  ; Carrega o endereço do registrador de dados da porta Q
    LDR     R2, [R1]                ; Lê o valor atual do registrador de dados
    BIC     R2, R2, #2_00001111     ; Limpa os bits PQ3:PQ0 (0b00001111)
    ORR     R2, R2, R0              ; Define os bits PQ3:PQ0 com o valor de R0
    STR     R2, [R1]                ; Escreve o valor atualizado no registrador de dados
    POP		{R1, R2, LR}
    BX      LR                      ; Retorna da função

; -------------------------------------------------------------------------------
; Função GPIOPortJ_Init
; Inicializa a porta J para interrupções
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIOPortJ_Init
    PUSH    {R0, R1, LR}
    ; PASSO 1 - Desabilitar interrupções
    MOV   R1, #0x00                 ; Limpa os bits de interrupção = 0
    LDR   R0, =GPIO_PORTJ_AHB_IM_R  ; Endereço do registrador IM para a porta J
    STR   R1, [R0]                  ; Escreve no registrador IM

    ; PASSO 2 - Configura o registrador de detecção de borda (IS) para a porta J
    MOV   R1, #0x00                 ; Configura o modo de detecção de borda = 0
    LDR   R0, =GPIO_PORTJ_AHB_IS_R  ; Endereço do registrador IS para a porta J
    STR   R1, [R0]                  ; Escreve no registrador IS

    ; PASSO 3.A - Configura o registrador de detecção de borda única (IBE) para a porta J
    MOV   R1, #0x00                 ; Configura o modo de detecção de borda única = 0
    LDR   R0, =GPIO_PORTJ_AHB_IBE_R ; Endereço do registrador IBE para a porta J
    STR   R1, [R0]                  ; Escreve no registrador IBE

    ; PASSO 3.B - Configuração borda IEV para a porta J alternativa
    MOV   R1, #0x00                 ; Configura o modo de detecção de borda de descida = 0
    LDR   R0, =GPIO_PORTJ_AHB_IEV_R ; Endereço do registrador IEV para a porta J
    STR   R1, [R0]                  ; Escreve no registrador IEV

    ; PASSO 4 - Limpa as interrupções pendentes no registrador ICR
    MOV   R1, #0x03                 ; Limpa as interrupções de PJ0 e PJ1 = 1
    LDR   R0, =GPIO_PORTJ_AHB_ICR_R ; Endereço do registrador ICR para a porta J
    STR   R1, [R0]                  ; Escreve no registrador ICR

    ; PASSO 5 - Habilita as interrupções no registrador IM
    MOV   R1, #0x03                 ; Habilita as interrupções de PJ0 e PJ1 = 1
    LDR   R0, =GPIO_PORTJ_AHB_IM_R  ; Endereço do registrador IM para a porta J
    STR   R1, [R0]                  ; Escreve no registrador IM

    ; PASSO 6 - Configura o registrador NVIC para habilitar a interrupção da porta J
    MOV     R1, #1                  ; Habilita a interrupção da porta J = 1
    LSL     R1, #19                 ; Desloca 19 bits para a esquerda para o bit correto
    LDR     R0, =NVIC_EN1_R         ; Endereço do registrador NVIC_EN1
    STR     R1, [R0]                ; Escreve no registrador NVIC_EN1

    ; PASSO 7.B - Configura a prioridade da interrupção no registrador NVIC_PRI12
    MOV     R1, #5                  ; Define a prioridade da interrupção = 5
    LSL     R1, #29                 ; Desloca 29 bits para a esquerda para o bit correto
    LDR     R0, =NVIC_PRI12_R       ; Endereço do registrador NVIC_PRI12
    STR     R1, [R0]                ; Escreve no registrador NVIC_PRI12

    POP  {R0, R1, LR}
    BX LR

; -------------------------------------------------------------------------------
; Função GPIOPortJ_Handler
; Interrupção da porta J (PJ0 e PJ1)
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIOPortJ_Handler
    PUSH    {R0,R1,LR}
    LDR R0, =GPIO_PORTJ_AHB_RIS_R       ; Endereço do RIS para a porta J
    LDR R1, [R0]                        ; Lê o valor do registrador de interrupção

VerificaJ0
    TST R1, #0x01                       ; Verifica se PJ0 gerou interrupção (bit 0)
    BEQ VerificaJ1                      ; Se não, verifica PJ1

    ; Lógica para PJ0
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Endereço do ICR para a porta J
    MOV R1, #0x01                       ; Limpa a interrupção de PJ0
    STR R1, [R0]                        ; Limpa a interrupção de PJ0
    ADD R5, R5, #1                      ; Incrementa o passo
    CMP R5, #10                         ; Verifica se o passo é maior que 10
    IT GE                               ; Se for maior ou igual a 10, reinicia o passo
    SUBGE R5, R5, #10                   ; Reinicia o passo para 0
    B Fim_Ver                           ; Sai da verificação de interrupção

VerificaJ1
    LDR R0, =GPIO_PORTJ_AHB_RIS_R       ; Endereço do RIS para a porta J
    LDR R1, [R0]                        ; Lê o valor do registrador de interrupção
    TST R1, #0x02                       ; Verifica se PJ1 gerou interrupção (bit 1)
    BEQ Fim_Ver                         ; Se não, sai da verificação

    ; Lógica para PJ1
    LDR R0, =GPIO_PORTJ_AHB_ICR_R       ; Endereço do ICR para a porta J
    MOV R1, #0x02                       ; Limpa a interrupção de PJ1
    STR R1, [R0]                        ; Limpa a interrupção de PJ1
    CMP R6, #0                          ; Verifica o modo atual (crescente ou decrescente)
    ITE EQ                              ; Se for crescente, muda para decrescente, e vice-versa
    MOVEQ R6, #1                        ; Alterna o modo
    MOVNE R6, #0                        ; Alterna o modo

Fim_Ver
    STR R1, [R0]                        ; Salva no registrador
    POP {R0, R1, LR}                    ; Restaura os registradores R0, R1 e LR da pilha
    BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------
    ALIGN                               ; Garante que o fim da seção está alinhado
    END                                 ; Fim do arquivo
