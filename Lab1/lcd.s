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
String_Passo DCB "Passo: ", 0
    EXPORT String_Passo [DATA,SIZE=8] ; Erro aqui, lê primeira letra e para

String_Crescente DCB "Crescente", 0
    EXPORT String_Crescente [DATA,SIZE=10] ; Erro aqui, lê primeira letra e para

String_Decrescente DCB "Decrescente", 0
    EXPORT String_Decrescente [DATA,SIZE=12] ; Erro aqui, lê primeira letra e para

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de código
    AREA |.text|, CODE, READONLY, ALIGN=2

    ; Se alguma função do arquivo for chamada em outro arquivo
    EXPORT LCD_Display ; Permite chamar a função Start a partir de outro arquivo. No caso startup.s
    EXPORT LCD_Init
    EXPORT LCD_WriteNumber

    ; Se chamar alguma função externa
    ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma função <func>
    IMPORT SysTick_Wait1us
    IMPORT PortK_Output
    IMPORT PortM_Output
    IMPORT Extract_Digits

;--------------------------------------------------------------------------------
; Função LCD_Init
; Inicializa os valores necessários para configurar o LCD
LCD_Init
    PUSH {R0, LR}
    MOV R0, #0x38                  ; Configuração do modo de 8 bits, 2 linhas, 5x8 pontos
    BL LCD_Command				   ; Envia para o LCD
    MOV R0, #0x06                  ; Deslocamento automático do cursor para a direita ao entrar com caracter
    BL LCD_Command				   ; Envia para o LCD
    MOV R0, #0x0E                  ; Liga o display e o cursor
    BL LCD_Command				   ; Envia para o LCD
    MOV R0, #0x01                  ; Comando para limpar o display
    BL LCD_Command				   ; Envia para o LCD
    MOV R0, #1600                  ; Valor de delay para inicialização (em us)
    BL SysTick_Wait1us             ; Aguarda 1600us (tempo de execução do comando)
    POP {R0, LR}
    BX LR

;--------------------------------------------------------------------------------
; Função LCD_Helper
; Envia comando de R0 para o LCD usando PORTK e PORTM
LCD_Command
    PUSH {R0, LR}                  ; Salva o registrador LR na pilha
    BL PortK_Output                ; Envia o sinal de R0 para o PK
    MOV R0, #0x04                  ; Habilita a escrita RS=1, RW=0, EN=1
    BL PortM_Output                ; Envia o sinal para o PM
    MOV R0, #10
    BL SysTick_Wait1us             ; Aguarda 10us (tempo para Enable)
    MOV R0, #0x00                  ; Limpa o sinal de habilitação RS=1, RW=0, EN=0
    BL PortM_Output                ; Envia o sinal para o PM
    MOV R0, #40
    BL SysTick_Wait1us             ; Aguarda 40us (tempo de execução do comando)
    POP {R0, LR}                   ; Restaura o registrador LR da pilha
    BX LR                          ; Retorna da função

;--------------------------------------------------------------------------------
; Função LCD_Data
; Envia dado de R0 para o LCD usando PORTK e PORTM
LCD_Data
    PUSH {R0, LR}                  ; Salva o registrador LR na pilha
    BL PortK_Output                ; Envia o sinal de R0 para o PK
    MOV R0, #0x05                  ; Habilita a escrita RS=1, RW=1, EN=1
    BL PortM_Output                ; Envia o sinal para o PM
    MOV R0, #10
    BL SysTick_Wait1us             ; Aguarda 10us (tempo para Enable)
    MOV R0, #0x00                  ; Limpa o sinal de habilitação RS=1, RW=1, EN=0
    BL PortM_Output                ; Envia o sinal para o PM
    MOV R0, #40
    BL SysTick_Wait1us             ; Aguarda 40us (tempo de execução do comando)
    POP {R0, LR}                   ; Restaura o registrador LR da pilha
    BX LR                          ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_WriteNumber
; Converte um número em ASCII e envia para o LCD
; Parâmetro de entrada: R0 --> Número a ser exibido
LCD_WriteNumber
    PUSH {R0, R1, R2, LR}   ; Salva os registradores usados
    BL Extract_Digits       ; Extrai os dígitos para R1 e R2
    ADD R1, R1, #48         ; Converte para ASCII ('0' = 48)
    MOV R0, R1              ; Move a dezena para R0
    BL LCD_Data             ; Envia a dezena para o LCD
    ADD R2, R2, #48         ; Converte para ASCII ('0' = 48)
    MOV R0, R2              ; Move a unidade para R0
    BL LCD_Data             ; Envia a unidade para o LCD
    POP {R0, R1, R2, LR}    ; Restaura os registradores usados
    BX LR                   ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_WriteString
; Envia uma string para o LCD
; Parâmetro de entrada: R0 --> Endereço da string
LCD_WriteString
    PUSH {R0, R1, R2, LR}   ; Salva o registrador LR na pilha
    MOV R2, R0              ; Copia o endereço da string para R2
Write_Loop
    LDRB R1, [R2], #1       ; Lê o próximo caractere da string
    CMP R1, #0              ; Verifica se é o caractere nulo (fim da string)
    BEQ Write_End           ; Se for nulo, termina a função
    MOV R0, R1              ; Move o caractere para R0
    BL LCD_Data             ; Envia o caractere para o LCD
    B Write_Loop            ; Continua enviando os próximos caracteres

Write_End
    POP {R0, R1, R2, LR}    ; Restaura o registrador LR da pilha
    BX LR                   ; Retorna da função

; -------------------------------------------------------------------------------
; Função LCD_Display
; Mostra na tela o valor do passo R5 e o modo R6 (Crescente ou Decrescente)
LCD_Display
    PUSH {R0, LR}
    MOV R0, #0x0E                   ; Liga o cursor
    BL LCD_Command                  ; Envia o comando para o LCD
    MOV R0, #0x01                   ; Limpa o display
    BL LCD_Command                  ; Envia o comando para o LCD
    LDR R0, =String_Passo           ; Carrega o endereço da string "Passo: "
    BL LCD_WriteString              ; Envia a string para o LCD
    MOV R0, R5                      ; Carrega o valor do passo em R0
    BL LCD_WriteNumber              ; Envia o valor do passo para o LCD
    MOV R0, #0xC0                   ; Comando para mover o cursor para a segunda linha
    BL LCD_Command                  ; Envia o comando para o LCD
    CMP R6, #0                      ; Verifica o modo (0 = crescente, 1 = decrescente)
    BEQ Modo_Crescente              ; Se for 0, exibe "Crescente"
    LDR R0, =String_Decrescente     ; Caso contrário, carrega "Decrescente"
    B Modo_Exibir

Modo_Crescente
    LDR R0, =String_Crescente       ; Carrega o endereço da string "Crescente"

Modo_Exibir
    BL LCD_WriteString              ; Envia a string para o LCD

    MOV R0, #0x0C                   ; Desliga o cursor
    BL LCD_Command                  ; Envia o comando para o LCD
    POP {R0, LR}
    BX LR                           ; Retorna da função

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------
    ALIGN                           ; Garante que o fim da seção está alinhado
    END                             ; Fim do arquivo
