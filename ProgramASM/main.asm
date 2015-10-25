 ;//////////////////////////////////////////////////////////////////////////////
; Laboratory AVR Microcontrollers Part1 
; Program template for lab 7
; Authors: Micha� Lytek & Jakub Swierczek
;
; Group: 5
; Section: 4
;
; Task: 
;
; Todo:
;
;
; Version: 0.5b
;//////////////////////////////////////////////////////////////////////////////
.nolist ;quartz assumption 4Mhz
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

ldi r16,0x00
ldi r17,0xFF

out DDRA,r16 ; PORTA - jako wejsciowy
out PORTA,r17 ; PORTA - wejscia PULL-UP
out DDRB,r17 ; PORTB - jako wyjscie
out PORTB,r16 ; PORTB - wyjscie w stan niski by diody nie �wieci�y

;------------------------------------------------------------------------------
; F2. Load initial values of index registers 
;  Z, X, Y 

ldi xl,0x00 ; nizsza czesc adresu - XL to rejest r28 (r28 i r27 to rejest X ) 
ldi xh,0x00 ; wyzsza czesc adresu 
ldi r21,0xFF ; rejestr do odczytu wartsci eeprom - ustawianie na FF, zeby pozniej przy czytaniu poprzednia wartosc nie byla zerem

CZEKAJ_NA_NACISNIECIE:
in r16, PINA ; wycztanie stanu portu A z przyciskami do rejestru
cpi r16, 0xFF ; por�wnanie bit�w w porcie z 1111 1111 - �aden z przycisk�w nie naci�ni�ty
breq CZEKAJ_NA_NACISNIECIE ; r�wne to powr�t do p�tli odczytu

CZYTAJ_PAMIEC: ; przycisk wci�ni�ty, odczytujemy pami�c eeprom
sbic eecr, eepe ; sprawdzenie czy pamiec zajeta w sumie
rjmp CZYTAJ_PAMIEC
out eearh, xh ;adresik
out eearl, xl
sbi eecr, eere ; czytanie
mov r20, r21 ; wartosc poptrzednia do r20
in r21, eedr
cp r20, r21
brne ZWIEKSZANIE_ADRESU
cpi r21, 0x00
breq End ; koniec pamieci

ZWIEKSZANIE_ADRESU:
cpi xl, 0xFF ; sprawdzenie czy nizsze bity adresu sie przepelnily
breq INKREMENTUJ_WYZSZE ; je�li nie - normalna inkrementacja
inc xl ; adres ++
rjmp WYPISZ_DANE
INKREMENTUJ_WYZSZE: ; gdy tak - inkrementujemy wy�sz� po��wk�
ldi xl, 0x00 ; wyzerowanie nizszych
inc xh ; adres ++

WYPISZ_DANE:
out portb, r21 ; zawarto�� odczytanego bajtu z eepromu na portB		 

CZEKAJ_NA_PUSZCZENIE:
in r16, PINA ; wycztanie stanu portu A z przyciskami do rejestru
cpi r16, 0xFF ; por�wnanie bit�w w porcie z 1111 1111 - �aden z przycisk�w nie naci�ni�ty
breq CZEKAJ_NA_NACISNIECIE ; r�wne to powr�t do p�tli oczekiwania na ponowne naci�ni�cie przycisku
rjmp CZEKAJ_NA_PUSZCZENIE; skok do petli czekania na puszczenie przycisku

;------------------------------------------------------------------------------
; Program end - Ending loop
;------------------------------------------------------------------------------
End:
rjmp END

;------------------------------------------------------------------------------
; Table Declaration -  place here test values
; Test with different table values and different begin addresses of table (als above 0x8000)
;
ROMTAB: .db 0xff
.EXIT
;------------------------------------------------------------------------------



