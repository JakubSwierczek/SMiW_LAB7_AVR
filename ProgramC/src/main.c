//////////////////////////////////////////////////////////////////////////////
/*; Laboratory AVR Microcontrollers Part1
; Program template for lab 9
;
; Authors:	Micha� Lytek
;			Jakub �wierczek
; Group:	5
; Section:	4
;
; Task:		Kopiowanie z ROM na diody + przerwania
; Todo:
; 	- ATmega2560 4 MHz		
;	- przyciski na porcie A zwieraj� do masy
;	- diody na porcie B przez rezystor do masy
;	- na ko�cu tablicy wartownik - dwie warto�ci 0x00
;	- gdy wci�ni�ty dowolny przycisk -> wy�wietlanie zawarto�ci tablicy na diodach (w p�tli)
;	- start programu dopiero po przyj�ciu zewn�trznego przerwania INT0 (pin PD0)
;	- po ka�dym odczytanym bajcie z ROMu i wy�wietleniu go na diodach - 1ms przerwy
;	- dok�adne odliczanie czasu za pomoc� sprz�towego licznika
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

//obs�uga przerwania od komparatora licznika - odliczanie czasu
volatile uint8_t flaga_licznika = 0x00;
ISR(TIMER0_COMPA_vect)
{
	flaga_licznika = 0xFF;
}
//obs�uga przerwania zewn�trznego - przycisk startu
volatile uint8_t flaga_startu = 0x00;
ISR(INT0_vect)
{
	flaga_startu = 0xFF;
}

//p�tla ustawienia licznika na 1ms i oczekiwania na odliczenie czasu
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

	//czekaj dop�ki licznik nie odliczy wymaganej warto�ci
	while (!flaga_licznika);
	flaga_licznika = 0x00; //zga� flag� licznika
	//odlicz drugi raz
	while (!flaga_licznika);
	flaga_licznika = 0x00; //zga� flag� licznika

	//zatrzymaj licznik
	TCCR0B &= ~((1<<CS02) | (1<<CS01) | (1<<CS00));
	TCNT0 = 0x00; //wyzeruj licznik
	TIMSK0 &= ~(1<<OCIE0A); //wy��cz przerwanie
}

//g��wna p�tla programu
int main(void)
{
	uint8_t poprzednia_wartosc = 0x00;
	uint8_t obecna_wartosc = 0xFF;
	DDRA = 0x00; // port A jako wejscie
	DDRB = 0xFF; // port B jako wyjscie
	DDRD &= ~(1<<PD0); // pin PD0 jako wej�cie
	PORTA = 0xFF; // pullupy na PORT A (przyciski do masy zwieraj�)
	PORTB = 0x00; // diody nie �wiec� na starcie
	//PORTD |= (1<<PD0); //pullup do przycisku na PD0
	
	//ustawienie generowania przerwania na INT0 przy opadaj�cym zboczu (1->0)
	EICRA |= (1<<ISC01); //1 na ISC01
	EICRA &= ~(1<<ISC00); //0 na ISC00
	EIMSK |= (1<<INT0); //odblokowanie przerwa� dla INT0

	sei(); //w��czenie przerwa� w programie

	//oczekiwanie na zg�oszenie przerwania INT0
	while(!flaga_startu); //czekaj, dop�ki flaga zg�oszenia przerwania INT0 nie jest ustawiona
	
	//czekaj a� dowolny przycisk na porcie A zostanie wci�ni�ty
	while(PINA == 0xFF);
	
	//dop�ki odczyt poprawny (nie jest to wartownik), to wypisz dane i przesu� wska�nik na kolejny bajt tablicy
	for (int offset = 0; czytaj_pamiec(offset, &poprzednia_wartosc, &obecna_wartosc); offset++)
	{
		czekaj(); //odczekaj 1ms pomi�dzy wypisaniem kolejnego bajtu
		wypisz_dane(obecna_wartosc);
	}
				
	while(1); //koniec dzia�ania programu
}

