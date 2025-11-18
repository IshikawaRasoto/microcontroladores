// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado das chaves USR_SW1 e USR_SW2, acende os LEDs 1 e 2 caso estejam pressionadas independentemente
// Caso as duas chaves estejam pressionadas ao mesmo tempo pisca os LEDs alternadamente a cada 500ms.
// Prof. Guilherme Peron
//
// Para o Lab03 - Led1(PN1) representara o PE0 e o Led 2(PN0) representara o PE1

#include <stdint.h>
#include "define.h"
#include "gpio.h"
#include "systick.h"
#include "tm4c1294ncpdt.h"
#include "uart.h"
#include "adc.h"
#include "timer.h"

typedef enum{
   Horario,
   AntiHorario
}Sentido;

void PLL_Init(void);

uint8_t estado = 2; // Passo do programa
volatile Sentido sentido = Horario; // 0 - Horario | 1 - Antihorario
volatile Sentido sentidoDesejado = Horario;
volatile uint16_t velocidadeDesejada = 0;
volatile uint16_t velocidadeAtual = 0;
volatile uint8_t estadoPE0 = 0;
volatile uint8_t estadoPE1 = 0;
volatile uint8_t estadoLed1 = 0; // PN1 Representa PE0
volatile uint8_t estadoLed2 = 0; // PN0 Representa PE1
volatile uint8_t estadoTimer = 0; // 0 - Na parte LOW do PWM | 1 - Na parte HIGH do PWM

// Controle do PWM
#define PERIODO 800000 // 800.000 - 10ms de periodo total
volatile uint32_t tempoHigh = 0;
volatile uint32_t tempoLow = 0;

void setHigh(){
    if(sentido == Horario){
        estadoPE0 = 0x1;
        estadoPE1 = 0x0;
        estadoLed1 = 0x1;
        estadoLed2 = 0x0;
        PortE_Output(0x1);
        PortN_Output(0x2);
    }else{
        estadoPE0 = 0x0;
        estadoPE1 = 0x1;
        estadoLed1 = 0x0;
        estadoLed2 = 0x1;
        PortE_Output(0x2);
        PortN_Output(0x1);
    }
}

void setLow(){
    estadoPE0 = 0x0;
    estadoPE1 = 0x0;
    estadoLed1 = 0x0;
    estadoLed2 = 0x0;
    PortE_Output(0x0);
    PortN_Output(0x0);
}

void Timer2A_Handler(){
    TIMER2_ICR_R = 0x01;
    if(velocidadeAtual == 0){ // Representacao de motor parado
        TIMER2_TAILR_R = 1999999; // 0.25 segundos.
        estadoPE0 = 0;
        estadoPE1 = 0;
        PortE_Output(0x00);
        if(!estadoLed1 && !estadoLed2){
            estadoLed1 = 0x1;
            estadoLed2 = 0x1;
            PortN_Output(0x3);
        }
        else{
            estadoLed1 = 0x0;
            estadoLed2 = 0x0;
            PortN_Output(0x0);
        }
        return;
    }

    if(!estadoTimer){
        estadoTimer = 0x1;
        TIMER2_TAILR_R = tempoHigh;
        setHigh();
    }else{
        estadoTimer = 0x0;
        TIMER2_TAILR_R = tempoLow;
        setLow();
    }

    return;
}

void printSentido(){
    print("Sentido Atual: ");
    println(sentido == Horario ? "Horario" : "AntiHorario");
    print("Sentido Desejado: ");
    println(sentidoDesejado == Horario ? "Horario" : "AntiHorario");
}

void printVelocidade(){
    print("Velocidade Atual: ");
    printNumero(velocidadeAtual);
    println("%");
    print("Velocidade Desejada: ");
    printNumero(velocidadeDesejada);
    println("%");
}

void calculoTemposVelocidade(uint16_t velocidadePercentual){
    if(velocidadePercentual == 0){
        tempoHigh = 0;
        tempoLow = 0;
    }

    tempoHigh = PERIODO * velocidadePercentual / 100;
    tempoLow = PERIODO - (tempoHigh);
}

void ajusteVelocidade(){
    if(sentidoDesejado != sentido){
        if(velocidadeAtual > 0)
            velocidadeAtual--;
        else if(velocidadeAtual == 0)
            sentido = sentidoDesejado;
        return;
    }
    if(velocidadeDesejada > velocidadeAtual){
        velocidadeAtual++;
    }else if(velocidadeDesejada < velocidadeAtual){
        velocidadeAtual--;
    }
    return;
}

void passo2(){
    velocidadeAtual = 0;
    velocidadeDesejada = 0;
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
            println("Velocidade selecionada: 50%");
            velocidadeDesejada = 50;
            break;
        case '6':
            println("Velocidade selecionada: 60%");
            velocidadeDesejada = 60;
            break;
        case '7':
            println("Velocidade selecionada: 70%");
            velocidadeDesejada = 70;
            break;
        case '8':
            println("Velocidade selecionada: 80%");
            velocidadeDesejada = 80;
            break;
        case '9':
            println("Velocidade selecionada: 90%");
            velocidadeDesejada = 90;
            break;
        case '0':
            println("Velocidade selecionada: 100%");
            velocidadeDesejada = 100;
            break;
        default:
            break;
    }
}

void selecionarSentido(char comando){
	if(comando == 'h'){
		println("Sentido horario selecionado");
		sentidoDesejado = Horario;
	}else{
	    println("Sentido antihorario selecionado");
		sentidoDesejado = AntiHorario;
	}
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
    selecionarVelocidade(comando);

    comando = 0;
		int contador = 0;
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
		if(contador == 10){
			contador = 0;
			printSentido();
			printVelocidade();
			println("---");
		}
		ajusteVelocidade();
		calculoTemposVelocidade(velocidadeAtual);
        contador ++;
        SysTick_Wait1ms(20);
    }

    estado = 2;
}

void passo5(){
    println("Controle via potenciometro");

    char comando = 0;
    int contador = 0;
    while(comando != 's'){
			comando = lerUART();
			uint32_t leitura = leituraADC();
			if(contador == 10){
				contador = 0;
				printSentido();
				printVelocidade();
				println("---");
			}
			if(leitura <= 2047){
					sentidoDesejado = AntiHorario;
					velocidadeDesejada = 100 - (leitura * 100 / 2047);
					if(velocidadeDesejada > 100)
							velocidadeDesejada = 100;
			}else{
					sentidoDesejado = Horario;
					velocidadeDesejada = (leitura - 2048) * 100 / 2047;
					if(velocidadeDesejada > 100)
							velocidadeDesejada = 100;
			}
			ajusteVelocidade();
			calculoTemposVelocidade(velocidadeAtual);
			contador++;
			SysTick_Wait1ms(20);
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
	configTimer();
	PortE_Output(0x00);
	PortF_Output(0x4);
	println("Timer iniciado");
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
                break;
		}
	}
}
