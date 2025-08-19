; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()
Start  
; Comece o código aqui <======================================================

	mov r0, #65
	mov r1, #0x1B00
	movt r1, #0x1B00
	mov r2, #0x5678
	movt r2, #0x1234
	mov r12, #0x0040
	movt r12, #0x2000
	str r0, [r12], #4; pos indexacao de 4
	str r1, [r12], #4
	str r2, [r12], #4	
	mov r11, #0xF001 
	str r11, [r12]
	mov r11, #0xCD
	mov r12, #0x0046
	movt r12, #0x2000
	strb r11, [r12]
	mov r12, #0x0040
	movt r12, #0x2000
	ldr r7, [r12], #8
	ldr r8, [r12]
	mov r9, r7
	nop
	

    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
