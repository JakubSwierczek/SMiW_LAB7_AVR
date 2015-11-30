//////////////////////////////////////////////////////////////////////////////
/*; Laboratory AVR Microcontrollers Part1
; Program template for lab 9
;
; Authors:	Micha³ Lytek
;			Jakub Œwierczek
; Group:	5
; Section:	4
;
; Task:		Kopiowanie z ROM na diody + przerwania
; Todo:
; 	- ATmega2560 4 MHz		
;	- przyciski na porcie A zwieraj¹ do masy
;	- diody na porcie B przez rezystor do masy
;	- na koñcu tablicy wartownik - dwie wartoœci 0x00
;	- gdy wciœniêty dowolny przycisk -> wyœwietlanie zawartoœci tablicy na diodach (w pêtli)
;	- start programu dopiero po przyjœciu zewnêtrznego przerwania INT0 (pin PD0)
;	- po ka¿dym odczytanym bajcie z ROMu i wyœwietleniu go na diodach - 1ms przerwy
;	- dok³adne odliczanie czasu za pomoc¹ sprzêtowego licznika
;
; Version: 1.2
;//////////////////////////////////////////////////////////////////////////////
*/
#define F_CPU 16000000L
#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>

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

//obs³uga przerwania od komparatora licznika - odliczanie czasu
volatile uint8_t flaga_licznika = 0x00;
ISR(TIMER0_COMPA_vect)
{
	flaga_licznika = 0xFF;
}
//obs³uga przerwania zewnêtrznego - przycisk startu
volatile uint8_t flaga_startu = 0x00;
ISR(INT0_vect)
{
	flaga_startu = 0xFF;
}

//pêtla ustawienia licznika na 1ms i oczekiwania na odliczenie czasu
void czekaj()
{
	//ustawienie preskalera na 8
	TCCR0B &= ~( (1<<CS02) | (1<<CS00) ); //wyzeruj bit CS02 i CS00
	TCCR0B |= (1<<CS01); //ustaw bity CS01 

	//ustawienie tryby licznika na CTC
	TCCR0B &= ~( (1<<WGM02) );	//0
	TCCR0A |= (1<<WGM01);		//1
	TCCR0A &= ~( (1<<WGM00) );	//0

	//250 * 8 = 2k -> 0.5ms przy 4MHz
	OCR0A = 249;
	TCNT0 = 0;

	//odblokuj przerwania dla komparatora A timera 0
	TIMSK0 |= (1<<OCIE0A);

	//czekaj dopóki licznik nie odliczy wymaganej wartoœci
	while (!flaga_licznika);
	flaga_licznika = 0x00; //zgaœ flagê licznika
	//odlicz drugi raz
	while (!flaga_licznika);
	flaga_licznika = 0x00; //zgaœ flagê licznika

	//zatrzymaj licznik
	TCCR0B &= ~((1<<CS02) | (1<<CS01) | (1<<CS00));
	TCNT0 = 0x00; //wyzeruj licznik
	TIMSK0 &= ~(1<<OCIE0A); //wy³¹cz przerwanie
}

//g³ówna pêtla programu
int main(void)
{
	uint8_t poprzednia_wartosc = 0x00;
	uint8_t obecna_wartosc = 0xFF;
	DDRA = 0x00; // port A jako wejscie
	DDRB = 0xFF; // port B jako wyjscie
	DDRD &= ~(1<<PD0); // pin PD0 jako wejœcie
	PORTA = 0xFF; // pullupy na PORT A (przyciski do masy zwieraj¹)
	PORTB = 0x00; // diody nie œwiec¹ na starcie
	//PORTD |= (1<<PD0); //pullup do przycisku na PD0
	
	//ustawienie generowania przerwania na INT0 przy opadaj¹cym zboczu (1->0)
	EICRA |= (1<<ISC01); //1 na ISC01
	EICRA &= ~(1<<ISC00); //0 na ISC00
	EIMSK |= (1<<INT0); //odblokowanie przerwañ dla INT0

	sei(); //w³¹czenie przerwañ w programie

	//oczekiwanie na zg³oszenie przerwania INT0
	while(!flaga_startu); //czekaj, dopóki flaga zg³oszenia przerwania INT0 nie jest ustawiona
	
	//czekaj a¿ dowolny przycisk na porcie A zostanie wciœniêty
	while(PINA == 0xFF);
	
	//dopóki odczyt poprawny (nie jest to wartownik), to wypisz dane i przesuñ wskaŸnik na kolejny bajt tablicy
	for (int offset = 0; czytaj_pamiec(offset, &poprzednia_wartosc, &obecna_wartosc); offset++)
	{
		czekaj(); //odczekaj 1ms pomiêdzy wypisaniem kolejnego bajtu
		wypisz_dane(obecna_wartosc);
	}
				
	while(1); //koniec dzia³ania programu
}

