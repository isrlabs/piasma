/*
 * Timer management code.
 *
 * This file contains code for interacting with the GPIO timer. The
 * primary function provided in this file is Wait, which takes a delay
 * in microseconds, stored in r0, and delays that long.
 */

/*
 * TimerAddress returns the address of the timer.
 */
.globl TimerAddress
TimerAddress:
  push  {lr}
  ldr   r0, =0x20003000
  pop   {pc}

/*
 * Timestamp returns the current timer as a 64-bit value in r0 (low)
 * and r1 (high).
 */
.globl Timestamp
Timestamp:
  push  {lr}
  bl    TimerAddress
  ldrd  r0, r1, [r0,#4]
  pop   {pc}

/*
 * Wait takes a 32-bit delay in microseconds (stored in r0), and waits
 * for that long before returning.
 */
.globl Wait
Wait:
  mov   r2, r0
  push  {lr}
  bl    Timestamp
  mov   r3, r0

  waitLoop$:
    bl  Timestamp
    sub r1, r0, r3
    cmp r1, r2
    bls waitLoop$
  
  pop   {pc}
