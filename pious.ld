/* Linker script derived from http://wiki.osdev.org/Linker_Scripts */
/*
ENTRY(_start)
STARTUP(objs/start.o)
 */

SECTIONS
{
	/*
	 * Kernel code starts at 0x8000, allowing room for vectors and ATAGs.
	 */
	.init 0x8000: {
		*(.init);
	}

	.text : {
		*(.text);
	}

	.data : {
		*(.data);
	}
}
