# Sistemas Microcontrolados - Projetos

Este repositório contém os laboratórios desenvolvidos para a disciplina de Sistemas Microcontrolados, utilizando a placa EK-TM4C129EXL. Os projetos implementam funcionalidades como controle de displays de 7 segmentos, inicialização de periféricos GPIO, configuração de PLL para ajuste de frequência de clock, e uso do SysTick para delays precisos.

## Descrição dos Laboratórios

### Lab0
- **Objetivo**: Introdução ao ambiente de desenvolvimento e ferramentas.
- **Arquivos principais**:
  - `exemplo.s`: Código de exemplo para configuração inicial.
  - `startup.s`: Configuração inicial do sistema.

### Lab1
- **Objetivo**: Implementar funcionalidades avançadas utilizando GPIO, displays de 7 segmentos, e LCD.
- **Arquivos principais**:
  - `main.s`: Função principal que controla o fluxo do programa.
  - `gpio.s`: Configuração e manipulação de portas GPIO.
  - `7seg.s`: Controle dos displays de 7 segmentos.
  - `lcd.s`: Controle do display LCD.
  - `utils.s`: Funções auxiliares, como configuração do PLL e SysTick.

## Funcionalidades Implementadas

- **Controle de GPIO**: Configuração de portas para entrada e saída digital.
- **Displays de 7 Segmentos**: Exibição de números de 0 a 99 com passo ajustável.
- **Display LCD**: Exibição de informações como passo e modo (crescente/decrescente).

## Como Executar

1. Abra o projeto no Keil uVision.
2. Compile o código.
3. Faça o upload para a placa EK-TM4C129EXL.
4. Resete a placa e observe os resultados nos displays e no LCD.

## Equipe

- Matheus Passos
- Lucas Yukio
- João Castilho Cardoso
