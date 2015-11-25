//////////////////////////////////////////////////////////////////////////////
/*; Laboratory AVR Microcontrollers Part1
; Program template for lab 7
;
; Authors:	Micha³ Lytek
;			Jakub Œwierczek
; Group:	5
; Section:	4
;
; Task:		Kopiowanie z ROM na diody
; Todo:
; 	- ATmega2560 16 MHz		
;	- przyciski na porcie A zwieraj¹ do masy
;	- diody na porcie B przez rezystor do masy
;	- na koñcu tablicy wartownik - dwie wartoœci 0x00
;	- gdy wciœniêty dowolny przycisk -> wyœwietlanie zawartoœci tablicy na diodach (w pêtli)
;
; Version: 1.1
;//////////////////////////////////////////////////////////////////////////////
*/
#define F_CPU 16000000L
#include <avr/io.h>
#include <avr/pgmspace.h>

//prototypy funkcji
void wypisz_dane(uint8_t dana);
uint8_t czytaj_pamiec(const int offset, uint8_t* poprzednia_wartosc, uint8_t* obecna_wartosc);

//testowa tablica w ROMie
const uint8_t PROGMEM romtab[10] = {0xF0, 0x10, 0xFF, 0x11, 0x00, 0x01, 0xFA, 0x23, 0x00, 0x00};

//odczytuje bajt pamiêci i porównuje z poprzednim, sprawdzaj¹c czy to wartownicy (koniec tablicy)
uint8_t czytaj_pamiec(const int offset, uint8_t* poprzednia_wartosc, uint8_t* obecna_wartosc)
{
	*poprzednia_wartosc = *obecna_wartosc;
	*obecna_wartosc = pgm_read_byte(&(romtab[offset])); //odczyt komórki pamiêci
	if(*obecna_wartosc == *poprzednia_wartosc && *obecna_wartosc == 0) //gdy mamy dwa zera w tablicy
		return 0x00; //koniec tablicy
	return 0xFF; //poprawny odczyt
	
}

//wypisanie bajtu na diody
void wypisz_dane(uint8_t dana)
{
	PORTB = dana;
}

//g³ówna pêtla programu
int main(void)
{
	uint8_t poprzednia_wartosc = 0x00;
	uint8_t obecna_wartosc = 0xFF;
	DDRA = 0x00; // port A jako wejscie
	DDRB = 0xFF; // port B jako wyjscie
	PORTA = 0xFF; // pullupy na PORT A (przyciski do masy zwieraj¹)
	PORTB = 0x00; // diody nie œwiec¹ na starcie
	
	while(1)
	{
		if(PINA != 0xFF) //je¿eli dowolny przycisk na porcie A jest wciœniêty
		{
			//dopóki odczyt poprawny (nie jest to wartownik), to wypisz dane i przesuñ wskaŸnik na kolejny bajt tablicy
			for (int offset = 0; czytaj_pamiec(offset, &poprzednia_wartosc, &obecna_wartosc); offset++)
				wypisz_dane(obecna_wartosc);
				
			while(1); //koniec dzia³ania programu
		}
	}
}

