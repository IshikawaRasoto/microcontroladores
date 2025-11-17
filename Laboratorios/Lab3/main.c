// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron

#include <stdint.h>
#include "define.h"
#include "gpio.h"
#include "systick.h"
#include "tm4c1294ncpdt.h"
#include "uart.h"
#include "adc.h"

typedef enum{
   Horario,
   AntiHorario
}Sentido;

void PLL_Init(void);

uint8_t estado = 2; // Passo do programa
volatile Sentido sentido = Horario; // 0 - Horario | 1 - Antihorario
volatile Sentido sentidoDesejado = Horario;
volatile uint16_t velocidadeDesejada = 50;
volatile uint16_t velocidadeAtual = 50;

void printSentido(){
    print("Sentido: ");
    println(sentido == Horario ? "Horario" : "AntiHorario");
}

void printVelocidade(){
    print("Velocidade Atual: ");
    printNumero(velocidadeAtual);
    println("%");
    print("Velocidade Desejada: ");
    printNumero(velocidadeDesejada);
    println("%");
}

void passo2(){
	println("Motor parado, pressione '*' para iniciar");
	char comando = 0;
	while(comando != '*'){
	    comando = lerUART();
	}
	estado = 3;
}

void passo3(){
    println("Defina o modo de operacao:");
    println("p - potenciomentro");
    println("t - terminal");
    char comando = 0;
    while(comando != 't' && comando != 'p'){
        comando = lerUART();
    }
    if(comando == 't'){
        estado = 4;
    }else{
        estado = 5;
    }
}

void selecionarVelocidade(char comando){
    switch(comando){
        case '5':
            break;
        case '6':
            break;
        case '7':
            break;
        case '8':
            break;
        case '9':
            break;
        case '0':
            break;
        default:
            break;
    }
}

void selecionarSentido(char comando){

}

void passo4(){
    println("Comando do motor via Terminal");
    println("a - Anti-horario");
    println("h - Horario");
    char comando = 0;
    while(comando!= 'a' && comando != 'h'){
        comando = lerUART();
    }
    selecionarSentido(comando);

    println("Selecione a velocidade desejada: ");
    println("5 - 50%");
    println("6 - 60%");
    println("7 - 70%");
    println("8 - 80%");
    println("9 - 90%");
    println("0 - 100%");

    comando = 0;
    while(  comando != '5' && comando != '6' && comando != '7' &&
            comando != '8' && comando != '9' && comando != '0')
    {
        comando = lerUART();
    }

    comando = 0;
    while(comando != 's'){
        comando = lerUART();
        if(comando == 'a' || comando == 'h'){
            selecionarSentido(comando);
            comando = 0;
        }else if(   comando == '5' || comando == '6' || comando == '7' ||
                    comando == '8' || comando == '9' || comando == '0')
        {
            selecionarVelocidade(comando);
            comando = 0;
        }
        printSentido();
        printVelocidade();
        println("---");
        SysTick_Wait1ms(1000);
    }

    estado = 2;
}

void passo5(){
    println("Controle via potenciometro");

    char comando = 0;
    while(comando != 's'){
        uint32_t leitura = leituraADC();

    }

    estado = 2;
}

int main(void)
{
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	configUART(9600);
	configADC();
	SysTick_Wait1ms(1000);
	println("Iniciando sistema...");
	SysTick_Wait1ms(500);
	println("Lab03 - Rafael Rasoto");
	print("\n");
	while (1)
	{
		switch (estado){
		    case 2:
				passo2();
				break;
			case 3:
			    passo3();
				break;
			case 4:
			    passo4();
				break;
			case 5:
			    passo5();
				break;
			default:
			    estado = 2;
		}
	}
}
