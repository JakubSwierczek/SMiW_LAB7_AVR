 ;//////////////////////////////////////////////////////////////////////////////
; Laboratory AVR Microcontrollers Part1 
; Program template for lab 7
; Authors: Micha³ Lytek & Jakub Swierczek
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

ldi r16,0x00 ;
ldi r17,0xFF ;
ldi xl,0x00 ; nizsza czesc adresu - XL to rejest r28 (r28 i r27 to rejest X ) 
ldi xh,0x00 ; wyzsza czesc adresu 
ldi r20,0x17 ; dana testsowa
ldi r21,0xFF ; rejest do odczytu wartsci eeprom - ustawianie na FF, zeby pozniej przy czytaniu poprzednia wartosc nie byla zerem

out DDRA,r16 ; PORTA - jako wejsciowy
out PINA,r17
;out PORTA,r17 ; PORTA - wejscia PULL-UP
out DDRB,r17 ; PORTB - jako wyjscie
out PORTB,r16 ; PORTB - wyjscie w stan niski by diody nie œwieci³y

;------------------------------------------------------------------------------
; F2. Load initial values of index registers 
;  Z, X, Y 

;MOZE_ZAPISZEMY_COS_NA_POCZATKU_DO_PAMIECI:
;sbic EECR,EEPE ; czekamy az poptrzebnie wpisanie sie nie skonczy, w sumie mogloby byc nie potrzebne wed³ug mnie
;rjmp MOZE_ZAPISZEMY_COS_NA_POCZATKU_DO_PAMIECI
;out EEARH, XH ; bity wyzsze adresu
;out EEARL, XL ; bity nizsze adresu
;out EEDR,r20 ; a te dane testowe wpiszemy pod ten adres
;sbi EECR,EEMPE ; trzeba zapisac wynik (tak mi sie wydaje, ze do tego sluzy)
;sbi EECR,EEPE ; je¿eli nie ustawimy tych dwoch bitow w eeepromie to nasza dana sie nie zapisze
; to sa jakies bity odpowiedzialne za czytanie, przy czytaniu sie je powinno sprawdzac zeby nie czytac jak sie pisze
;cbi EECR,EEPE ; probowalem wyzerowac ten bit, tak aby mozna bylo spokojnie przeczytac pamiec


CZEKAJ_NA_NACISNIECIE:
in r16, PINA ; wycztanie stanu portu A z przyciskami do rejestru
cpi r16, 0xFF ; porównanie bitów w porcie z 1111 1111 - ¿aden z przycisków nie naciœniêty
breq CZEKAJ_NA_NACISNIECIE ; równe to powrót do pêtli odczytu
ldi r17, 0x00
ldi r18, 0x00
;in r18, 0x00		 ; gdy nie, to przycisk wciœniêty i kopiujemy bajt
rjmp CZYTAJ_PAMIEC
WYPISZ_DANE:
out portb, r21		 

CZEKAJ_NA_PUSZCZENIE:
in r16, PINA ; wycztanie stanu portu A z przyciskami do rejestru
cpi r16, 0xFF ; porównanie bitów w porcie z 1111 1111 - ¿aden z przycisków nie naciœniêty
breq CZEKAJ_NA_NACISNIECIE ; równe to powrót do pêtli odczytu
rjmp CZEKAJ_NA_PUSZCZENIE; skok do petli czekania na puszczenie przycisku

/*CZYTAJ_PAMIEC_PIERWSZY_ELEMENT:
; z racji ze sie nie udalo zrbic tak, zeby moc od razu pisac i czytac pamiec albo juz nie mysle 
; to po prostu nie sprawdzam czy jest zajeta
;sbic eecr, eepe ;sprawdzanie czy pameic jest zajeta
;rjmp CZYTAJ_PAMIEC
;out eearh, XH ; set-up address
;out eearl, XL 
;sbi eecr, eere ; pozowolenie odczytu
;in r21, eedr ; czytanie danych
;in r20, eedr ; dwa razy ta sama dana, zeby pozniej mozna bylo porownac
;rjmp WYPISZ_DANE*/

CZYTAJ_PAMIEC:
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
breq INKREMENTUJ_WYZSZE
inc xl ; adres ++
rjmp WYPISZ_DANE
INKREMENTUJ_WYZSZE:
ldi xl, 0x00 ; wyzerowanie nizszych
inc xh ; 
rjmp WYPISZ_DANE

;------------------------------------------------------------------------------
; Program end - Ending loop
;------------------------------------------------------------------------------
End:
rjmp END

;------------------------------------------------------------------------------
; Table Declaration -  place here test values
; Test with different table values and different begin addresses of table (als above 0x8000)
;
;ROMTAB: .db 0xffh
.EXIT
;------------------------------------------------------------------------------



