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
;	- ATmega2560 16 MHz	
;	- przyciski na porcie A zwieraj¹ do masy
;	- diody na porcie B przez rezystor do masy
;	- na koñcu tablicy wartownik - dwie wartoœci 0x00
;	- gdy wciœniêty dowolny przycisk -> wyœwietlanie zawartoœci tablicy na diodach (w pêtli)
;
; Version: 1.1
;//////////////////////////////////////////////////////////////////////////////
*/
.nolist ;quartz assumption 16 MHz
.include "m2560def.inc"
.list

;//////////////////////////////////////////////////////////////////////////////
; EEPROM - data non volatile memory segment 
.ESEG 

;//////////////////////////////////////////////////////////////////////////////
; StaticRAM - data memory.segment
.DSEG 
.ORG 0x200; may be omitted this is default value
; Destination table (xlengthx bytes). 
; Replace "xlengthx" with correct value
RAMTAB: .BYTE 256 
FLAGA_STARTU: .db 0x00
FLAGA_LICZNIKA: .db 0x00

;//////////////////////////////////////////////////////////////////////////////
; CODE - Program memory segment
; Please Remember that it is "word" address space
;
.CSEG  
.org 0x0000 ; may be omitted this is default value 
jmp	RESET	; Reset Handler

; Interrupts vector table / change to your procedure only when needed 
jmp my_INT0_ISR ; IRQ0 Handler
jmp INT1_ISR ; IRQ1 Handler
jmp INT2_ISR ; IRQ2 Handler
jmp INT3_ISR ; IRQ3 Handler
jmp INT4_ISR ; IRQ4 Handler
jmp INT5_ISR ; IRQ5 Handler
jmp INT6_ISR ; IRQ6 Handler
jmp INT7_ISR ; IRQ7 Handler
jmp PCINT0_ISR ; PCINT0 Handler
jmp PCINT1_ISR ; PCINT1 Handler
jmp PCINT2_ISR ; PCINT2 Handler
jmp WDT ; Watchdog Timeout Handler
jmp TIM2_COMPA ; Timer2 CompareA Handler
jmp TIM2_COMPB ; Timer2 CompareB Handler
jmp TIM2_OVF ; Timer2 Overflow Handler
jmp TIM1_CAPT ; Timer1 Capture Handler
jmp TIM1_COMPA ; Timer1 CompareA Handler
jmp TIM1_COMPB ; Timer1 CompareB Handler
jmp TIM1_COMPC ; Timer1 CompareC Handler
jmp TIM1_OVF ; Timer1 Overflow Handler
jmp my_TIM0_COMPA_ISR ; Timer0 CompareA Handler
jmp TIM0_COMPB ; Timer0 CompareB Handler
jmp TIM0_OVF ; Timer0 Overflow Handler
jmp SPI_STC ; SPI Transfer Complete Handler
jmp USART0_RXC ; USART0 RX Complete Handler
jmp USART0_UDRE ; USART0,UDR Empty Handler
jmp USART0_TXC ; USART0 TX Complete Handler
jmp ANA_COMP ; Analog Comparator Handler
jmp ADC_INT ; ADC Conversion Complete
jmp EE_RDY ; EEPROM Ready Handler
jmp TIM3_CAPT ; Timer3 Capture Handler
jmp TIM3_COMPA ; Timer3 CompareA Handler
jmp TIM3_COMPB ; Timer3 CompareB Handler
jmp TIM3_COMPC ; Timer3 CompareC Handler
jmp TIM3_OVF ; Timer3 Overflow Handler
jmp USART1_RXC ; USART1 RX Complete Handler
jmp USART1_UDRE ; USART1,UDR Empty Handler
jmp USART1_TXC ; USART1 TX Complete Handler
jmp TWI ; 2-wire Serial Handler
jmp SPM_RDY ; SPM Ready Handler
jmp TIM4_CAPT ; Timer4 Capture Handler
jmp TIM4_COMPA ; Timer4 CompareA Handler
jmp TIM4_COMPB ; Timer4 CompareB Handler
jmp TIM4_COMPC ; Timer4 CompareC Handler
jmp TIM4_OVF ; Timer4 Overflow Handler
jmp TIM5_CAPT ; Timer5 Capture Handler
jmp TIM5_COMPA ; Timer5 CompareA Handler
jmp TIM5_COMPB ; Timer5 CompareB Handler
jmp TIM5_COMPC ; Timer5 CompareC Handler
jmp TIM5_OVF ; Timer5 Overflow Handler
jmp USART2_RXC ; USART2 RX Complete Handler
jmp USART2_UDRE ; USART2,UDR Empty Handler
jmp USART2_TXC ; USART2 TX Complete Handler
jmp USART3_RXC ; USART3 RX Complete Handler
jmp USART3_UDRE ; USART3,UDR Empty Handler
jmp USART3_TXC ; USART3 TX Complete Handler

;//////////////////////////////////////////////////////////////////////////////
INT1_ISR : ; IRQ1 Handler
INT2_ISR : ; IRQ2 Handler
INT3_ISR : ; IRQ3 Handler
INT4_ISR : ; IRQ4 Handler
INT5_ISR : ; IRQ5 Handler
INT6_ISR : ; IRQ6 Handler
INT7_ISR : ; IRQ7 Handler
PCINT0_ISR : ; PCINT0 Handler
PCINT1_ISR : ; PCINT1 Handler
PCINT2_ISR : ; PCINT2 Handler
WDT : ; Watchdog Timeout Handler
TIM2_COMPA : ; Timer2 CompareA Handler
TIM2_COMPB : ; Timer2 CompareB Handler
TIM2_OVF : ; Timer2 Overflow Handler
TIM1_CAPT : ; Timer1 Capture Handler
TIM1_COMPA : ; Timer1 CompareA Handler
TIM1_COMPB : ; Timer1 CompareB Handler
TIM1_COMPC : ; Timer1 CompareC Handler
TIM1_OVF : ; Timer1 Overflow Handler
TIM0_COMPB : ; Timer0 CompareB Handler
TIM0_OVF : ; Timer0 Overflow Handler
SPI_STC : ; SPI Transfer Complete Handler
USART0_RXC : ; USART0 RX Complete Handler
USART0_UDRE : ; USART0,UDR Empty Handler
USART0_TXC : ; USART0 TX Complete Handler
ANA_COMP : ; Analog Comparator Handler
ADC_INT : ; ADC Conversion Complete
EE_RDY : ; EEPROM Ready Handler
TIM3_CAPT : ; Timer3 Capture Handler
TIM3_COMPA : ; Timer3 CompareA Handler
TIM3_COMPB : ; Timer3 CompareB Handler
TIM3_COMPC : ; Timer3 CompareC Handler
TIM3_OVF : ; Timer3 Overflow Handler
USART1_RXC : ; USART1 RX Complete Handler
USART1_UDRE : ; USART1,UDR Empty Handler
USART1_TXC : ; USART1 TX Complete Handler
TWI : ; 2-wire Serial Handler
SPM_RDY : ; SPM Ready Handler
TIM4_CAPT : ; Timer4 Capture Handler
TIM4_COMPA : ; Timer4 CompareA Handler
TIM4_COMPB : ; Timer4 CompareB Handler
TIM4_COMPC : ; Timer4 CompareC Handler
TIM4_OVF : ; Timer4 Overflow Handler
TIM5_CAPT : ; Timer5 Capture Handler
TIM5_COMPA : ; Timer5 CompareA Handler
TIM5_COMPB : ; Timer5 CompareB Handler
TIM5_COMPC : ; Timer5 CompareC Handler
TIM5_OVF : ; Timer5 Overflow Handler
USART2_RXC : ; USART2 RX Complete Handler
USART2_UDRE : ; USART2,UDR Empty Handler
USART2_TXC : ; USART2 TX Complete Handler
USART3_RXC : ; USART3 RX Complete Handler
USART3_UDRE : ; USART3,UDR Empty Handler
USART3_TXC : ; USART3 TX Complete Handler
reti		; return from all no used

my_INT0_ISR : ; IRQ0 Handler
	ser r18
	sts FLAGA_STARTU, r18
reti

my_TIM0_COMPA_ISR : ; Timer0 CompareA Handler
	ser r18
	sts FLAGA_LICZNIKA, r18
reti

;//////////////////////////////////////////////////////////////////////////////
; Program start
RESET:

cli 		; disable all interrupts
;  Set stack pointer to top of RAM
ldi R16, HIGH(RAMEND)
out SPH, R16
ldi R16, LOW(RAMEND)
out SPL, R16

;------------------------------------------------------------------------------
; Main program code place here
; 1. Place here code related to initialization of ports and interrupts

clr r16				; ustawienie 0x00 w rejestrze
ser r17				; ustawienie 0xFF w rejestrze

out DDRA, r16		; PORTA - jako wejsciowy
out PORTA, r17		; PORTA - wejscia PULL-UP
out DDRB, r17		; PORTB - jako wyjscie
out PORTB, r16		; PORTB - wyjscie w stan niski by diody nie œwieci³y
in r16, DDRD
cbr r16, (1<<PD0); PD0 jako wejœcie
out DDRD, r16

;------------------------------------------------------------------------------
; F2. Load initial values of index registers 
;  Z, X, Y 
					; ³adowanie rejestru Z adresem tablicy
ldi zl, low(ROMTAB << 1)
ldi zh, high(ROMTAB << 1)
ldi r21, 0xFF		; rejestr do odczytu wartsci eeprom - ustawianie na FF, zeby pozniej przy czytaniu poprzednia wartosc nie byla zerem

;------------------------------------------------------------------------------
; Kod g³ównej czêœci programu
;------------------------------------------------------------------------------

; ustawienie generowania przerwania na INT0 przy opadaj¹cym zboczu (1->0)
lds r16, EICRA
sbr r16, (1<<ISC01) ; 1 na ISC01
cbr r16, (1<<ISC00) ; 0 na ISC00
sts EICRA, r16

; odblokowanie przerwañ dla INT0
in r16, EIMSK
sbr r16, (1<<INT0)
out EIMSK, r16

; ustawienie preskalera licznika na 8 i trybu licznika na CTC
in r16, TCCR0B
; wyzeruj bity CS02, CS00 i WGM02	
cbr r16, (1<<CS02) | (1<<CS00) | (1<<WGM02)	
sbr r16, (1<<CS01) 				; ustaw bit CS01
out TCCR0B, r16					; zapisz now¹ wartoœæ
in r16, TCCR0A
cbr r16, (1<<WGM00)				; wyzeruj bit WGM00
sbr r16, (1<<WGM01)				; ustaw bit WGM01
out TCCR0A, r16

; 250 * 8 = 4k -> 0.5ms przy 4MHz
ldi r16, 250
out OCR0A, r16					; ustawienie wartoœci komparatora

; w³¹czenie przerwañ w programie
sei

CZEKAJ_NA_INT0:			; sprawdŸ czy flaga startu zosta³a ustawiona przez przerwanie INT0
lds r16, FLAGA_STARTU	; wczytaj flagê do rejestru
cpi r16, 0x00			; porównaj z zerem
breq CZEKAJ_NA_INT0		; jeœli zero, to dalej w pêtli

CZEKAJ_NA_NACISNIECIE:
in r16, PINA		; wycztanie stanu portu A z przyciskami do rejestru
cpi r16, 0xFF		; porównanie bitów w porcie z 1111 1111 - ¿aden z przycisków nie naciœniêty
breq CZEKAJ_NA_NACISNIECIE	; równe to powrót do pêtli odczytu

CZYTAJ_PAMIEC:		; przycisk wciœniêty, odczytujemy pamiêc eeprom
mov r20, r21		; wartosc poptrzednia do r20
lpm r21, Z+			; czytanie tablicy oraz inkrementacja wskaznika

cp r20, r21			; sprawdzanie czy obecna i poprzednia wartoœæ s¹ takie same
brne WYPISZ_DANE	; jezeli nie to wypisujemy dane
cpi r21, 0x00		; jeœli s¹ takie same to czy nie sa zerami
breq End			; napotkanie wartownika -> koniec programu

WYPISZ_DANE:
; ustaw stan pocz¹tkowy licznika
ldi r16, 0
out TCNT0, r16			; ustawienie stanu licznika -> 250 zliczeñ

; odblokowanie przerwania dla komparatora A timera 0
lds r16, TIMSK0
sbr r16, (1<<OCIE0A)	; 1 na bicie OCIE0A
sts TIMSK0, r16

; 2 pêtle oczekiwania po 0,5 ms
CZEKAJ_NA_KONIEC_1:
lds r16, FLAGA_LICZNIKA
cpi r16, 0x00
breq CZEKAJ_NA_KONIEC_1

clr r16					
sts FLAGA_LICZNIKA, r16 ; ustaw flagê licznika

CZEKAJ_NA_KONIEC_2:
lds r16, FLAGA_LICZNIKA
cpi r16, 0x00
breq CZEKAJ_NA_KONIEC_2

; wypisz dane
out PORTB, r21		; zawartoœæ odczytanego bajtu z tablicy na port B (diody)

; wy³¹czanie odliczania
lds r16, TIMSK0			; wy³¹cz przerwanie od komparatora A licznika 0
cbr r16, (1<<OCIE0A)	; 0 na bicie OCIE0A
sts TIMSK0, r16
clr r16					; ustaw flagê licznika
sts FLAGA_LICZNIKA, r16

; pêtla - skok do odczytywania bajtów z tablicy
rjmp CZYTAJ_PAMIEC		

;------------------------------------------------------------------------------
; Program end - Ending loop
;------------------------------------------------------------------------------
End:
rjmp END

;------------------------------------------------------------------------------
; Table Declaration -  place here test values
; Test with different table values and different begin addresses of table (als above 0x8000)
;
ROMTAB: .db 0xff, 0xf0, 0x42, 0x10, 0x00, 0x00
.EXIT
;------------------------------------------------------------------------------



