.section .init
.globl _start
_start:
	mov	sp,	#0x800
	b	main
