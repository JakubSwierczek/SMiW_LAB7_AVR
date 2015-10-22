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
#include <avr/io.h>
#include <avr/pgmspace.h>

#define nLength 100
/*
uint8_t TAB_ROM[] PROGMEM = { 0x00, 0x00 };
uint8_t TAB_RAM[nLength];
*/
// uncomment if needed
// #define GET_FAR_ADDRESS(var) \
//({ \
//uint_farptr_t tmp; \
//__asm__ __volatile__( \
//"ldi %A0, lo8(%1)" "\n\t" \
//"ldi %B0, hi8(%1)" "\n\t" \
//"ldi %C0, hh8(%1)" "\n\t" \
//"clr %D0" "\n\t" \
//: \
//"=d" (tmp) \
//: \
//"p" (&(var)) \
//); \
//tmp; \
//})

//---------------------------------------------------------------------
void main (void)
{
	//---------------------------------------------------------------------
	// Main program code place here
	// 1. Place here code related to initialization of ports and interrupts
	// for instancje port A as output and initial value 0
	// DDRA=0xFF
	// PORTA=0x00

	// 2. Enable interrupts if needed
	// sei();

	// 3. Place here main code


	//----------------------------------------------------------------------
	// Program end
	//----------------------------------------------------------------------
}
// -------------------------------------------------------------------
