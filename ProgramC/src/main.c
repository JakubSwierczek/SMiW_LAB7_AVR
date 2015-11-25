//////////////////////////////////////////////////////////////////////////////
/*; Laboratory AVR Microcontrollers Part1
; Program template for lab 7
;
; Authors:	Micha� Lytek
;			Jakub �wierczek
; Group:	5
; Section:	4
;
; Task:		Kopiowanie z ROM na diody
; Todo:
; 	- ATmega2560 16 MHz		
;	- przyciski na porcie A zwieraj� do masy
;	- diody na porcie B przez rezystor do masy
;	- na ko�cu tablicy wartownik - dwie warto�ci 0x00
;	- gdy wci�ni�ty dowolny przycisk -> wy�wietlanie zawarto�ci tablicy na diodach (w p�tli)
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

//odczytuje bajt pami�ci i por�wnuje z poprzednim, sprawdzaj�c czy to wartownicy (koniec tablicy)
uint8_t czytaj_pamiec(const int offset, uint8_t* poprzednia_wartosc, uint8_t* obecna_wartosc)
{
	*poprzednia_wartosc = *obecna_wartosc;
	*obecna_wartosc = pgm_read_byte(&(romtab[offset])); //odczyt kom�rki pami�ci
	if(*obecna_wartosc == *poprzednia_wartosc && *obecna_wartosc == 0) //gdy mamy dwa zera w tablicy
		return 0x00; //koniec tablicy
	return 0xFF; //poprawny odczyt
	
}

//wypisanie bajtu na diody
void wypisz_dane(uint8_t dana)
{
	PORTB = dana;
}

//g��wna p�tla programu
int main(void)
{
	uint8_t poprzednia_wartosc = 0x00;
	uint8_t obecna_wartosc = 0xFF;
	DDRA = 0x00; // port A jako wejscie
	DDRB = 0xFF; // port B jako wyjscie
	PORTA = 0xFF; // pullupy na PORT A (przyciski do masy zwieraj�)
	PORTB = 0x00; // diody nie �wiec� na starcie
	
	while(1)
	{
		if(PINA != 0xFF) //je�eli dowolny przycisk na porcie A jest wci�ni�ty
		{
			//dop�ki odczyt poprawny (nie jest to wartownik), to wypisz dane i przesu� wska�nik na kolejny bajt tablicy
			for (int offset = 0; czytaj_pamiec(offset, &poprzednia_wartosc, &obecna_wartosc); offset++)
				wypisz_dane(obecna_wartosc);
				
			while(1); //koniec dzia�ania programu
		}
	}
}

