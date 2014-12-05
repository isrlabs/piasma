.section .text
.globl main
main:
	mov	r0,	#47
	mov	r1,	#1
	bl	SetGPIOFunction

	mov	r0,	#47
	mov	r1,	#1
	bl	SetGPIO

_loop$:
	b	_loop$
		
