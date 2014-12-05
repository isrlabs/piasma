/*
 * Operating system "shell"
 *
 * This is the code that ends up running on the Pi as the main
 * entrypoint.
 */
.section .text
.globl main
main:
	mov	r0,	#47
	mov	r1,	#1
	bl	SetGPIOFunction

/*
 * Current functionality: blink the ACT LED.
 */
_loop$:
	mov	r0,	#47
	mov	r1,	#1
	bl	SetGPIO

	ldr	r0,	=100000
	bl	Wait

	mov	r0,	#47
	mov	r1,	#0
	bl	SetGPIO

	ldr	r0,	=100000
	bl	Wait

	b	_loop$

