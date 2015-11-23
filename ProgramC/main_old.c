//////////////////////////////////////////////////////////////////////////////
/*; Laboratory AVR Microcontrollers Part1
; Program template for lab 21
; Authors:
;
; Group:
; Section:
;
; Task:
;
; Todo:
;
;
; Version: 1.0
;//////////////////////////////////////////////////////////////////////////////
*/
#define F_CPU 16000000L
#include <avr/io.h>
#include <avr/eeprom.h>
#include <avr/pgmspace.h>

#define GET_FAR_ADDRESS(var) \
({ \
	uint_farptr_t tmp; \
	\
	__asm__ __volatile__( \
	\
	"ldi %A0, lo8(%1)" "\n\t" \
	"ldi %B0, hi8(%1)" "\n\t" \
	"ldi %C0, hh8(%1)" "\n\t" \
	"clr %D0" "\n\t" \
	: \
	"=d" (tmp) \
	: \
	"p" (&(var)) \
	); \
	tmp; \
})
void wypisz_dane(uint8_t dana);
uint8_t czytaj_pamiec(const int offset, uint8_t* poprzednia_wartosc, uint8_t* obecna_wartosc);
const uint8_t PROGMEM romtab[10] = {0xF0, 0x10, 0xFF, 0x11, 0x00, 0x01, 0xFA, 0x23, 0x00, 0x00};
	
	
uint8_t czytaj_pamiec(const int offset, uint8_t* poprzednia_wartosc, uint8_t* obecna_wartosc)
{
	*poprzednia_wartosc = *obecna_wartosc;
	*obecna_wartosc = eeprom_read_byte(offset); //odczyt komórki pamiêci
	if(*obecna_wartosc == *poprzednia_wartosc && *obecna_wartosc == 0) //gdy mamy dwa zera w tablicy
		return 0x00; //koniec tablicy
	return 0xFF; //poprawny odczyt
	
}

void wypisz_dane(uint8_t dana)
{
	PORTB = dana;
}
int main(void)
{
	int offset = 0;
	uint8_t czy_wpisac = 0x00;
	uint8_t poprzednia_wartosc = 0x00;
	uint8_t obecna_wartosc = 0xFF;
	DDRA = 0x00; // wejscie
	DDRB = 0xFF; // wyjscie
	PORTA = 0xFF; // + pullup-y
	//PINA = 0xFF;
	PORTB = 0x00; //diody nie œwiec¹
	//PINB = 0x00;
	
	while(1)
	{
		if(PINA != 0xFF)
		{
			czy_wpisac = czytaj_pamiec(offset, &poprzednia_wartosc, &obecna_wartosc);
			if(czy_wpisac == 0xFF)
			{
				offset++; //poprawna wartoœæ odczytana, przesuwamy siê na kolejny bajt tablicy
				wypisz_dane(obecna_wartosc);
			}
			else
				return 0; //wyjscie z programu - koniec dzia³ania
				
			while (PINA != 0xFF) {} //dopóki któryœ przycisk naciœniêty, czekamy na puszczenie go
		}	
	}
	
	
	return 0;
}
	
