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
.include "2560def.inc"
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

;//////////////////////////////////////////////////////////////////////////////
; CODE - Program memory segment
; Please Remember that it is "word" address space
;
.CSEG  
.org 0x0000 ; may be omitted this is default value 
jmp	RESET	; Reset Handler

; Interrupts vector table / change to your procedure only when needed 
jmp	EXT_INT0	; IRQ0 Handler
jmp	EXT_INT1	; IRQ1 Handler
jmp	EXT_INT2	; IRQ2 Handler
jmp	EXT_INT3	; IRQ3 Handler
jmp	EXT_INT4	; IRQ4 Handler
jmp	EXT_INT5	; IRQ5 Handler
jmp	EXT_INT6	; IRQ6 Handler
jmp	EXT_INT7	; IRQ7 Handler
jmp	TIM2_COMP	; Timer2 Compare Handler
jmp	TIM2_OVF   	;Timer2 Overflow Handler
jmp	TIM1_CAPT 	;Timer1 Capture Handler
jmp	TIM1_C0MPA	;Timer1 CompareA Handler
jmp	TIM1_C0MPB	;Timer1 CompareB Handler
jmp	TIM1_0VF  	;Timer1 Overflow Handler
jmp	TIM0_COMP 	;Timer0 Compare Handler
jmp	TIM0_OVF  	;Timer0 Overflow Handler
jmp	SPI_STC   	;SPI Transfer Complete Handler
jmp	USART0_RXC	;USART0 RX Complete Handler
jmp	USART0_DRE	;USART0,UDR Empty Handler
jmp	USART0_TXC	;USART0 TX Complete Handler
jmp	ADC1       	;ADC Conversion Complete Handler
jmp	EE_RDY    	;EEPROM Ready Handler
jmp	ANA_COMP  	;Analog Comparator Handler
jmp	TIM1_C0MPC	;Timer1 CompareC Handler
jmp	TIM3_CAPT 	;Timer3 Capture Handler
jmp	TIM3_COMPA	;Timer3 CompareA Handler
jmp	TIM3_COMPB	; Timer3 CompareB Handler
jmp	TIM3_COMPC	;Timer3 CompareC Handler
jmp	TIM3_OVF  	;Timer3 Overflow Handler
jmp	USART1_RXC	;USART1 RX Complete Handler
jmp	USART1_DRE	;USART1,UDR Empty Handler
jmp	USART1_TXC	;USART1 TX Complete Handler
jmp	TWI        	;Two-wire Serial Interface Interrupt Handler
jmp	SPM_RDY   	;SPM Ready Handler

;//////////////////////////////////////////////////////////////////////////////
EXT_INT0:	; IRQ0 Handler
EXT_INT1:	; IRQ1 Handler
EXT_INT2:	; IRQ2 Handler
EXT_INT3:	; IRQ3 Handler
EXT_INT4:	; IRQ4 Handler
EXT_INT5:	; IRQ5 Handler
EXT_INT6:	; IRQ6 Handler
EXT_INT7:	; IRQ7 Handler
TIM2_COMP:	; Timer2 Compare Handler
TIM2_OVF:   ;Timer2 Overflow Handler
TIM1_CAPT:  ;Timer1 Capture Handler
TIM1_C0MPA: ;Timer1 CompareA Handler
TIM1_C0MPB: ;Timer1 CompareB Handler
TIM1_0VF:   ;Timer1 Overflow Handler
TIM0_COMP:  ;Timer0 Compare Handler
TIM0_OVF:   ;Timer0 Overflow Handler
SPI_STC:    ;SPI Transfer Complete Handler
USART0_RXC: ;USART0 RX Complete Handler
USART0_DRE: ;USART0,UDR Empty Handler
USART0_TXC: ;USART0 TX Complete Handler
ADC1:       ;ADC Conversion Complete Handler
EE_RDY:     ;EEPROM Ready Handler
ANA_COMP:   ;Analog Comparator Handler
TIM1_C0MPC: ;Timer1 CompareC Handler
TIM3_CAPT:  ;Timer3 Capture Handler
TIM3_COMPA: ;Timer3 CompareA Handler
TIM3_COMPB: ; Timer3 CompareB Handler
TIM3_COMPC: ;Timer3 CompareC Handler
TIM3_OVF:   ;Timer3 Overflow Handler
USART1_RXC: ;USART1 RX Complete Handler
USART1_DRE: ;USART1,UDR Empty Handler
USART1_TXC: ;USART1 TX Complete Handler
TWI:        ;Two-wire Serial Interface Interrupt Handler
SPM_RDY:    ;SPM Ready Handler
reti		; return from all no used

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
out PORTB, r21		; zawartoœæ odczytanego bajtu z tablicy na port B (diody)	 
rjmp CZYTAJ_PAMIEC	; pêtla - skok do odczytywania bajtów z tablicy

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



