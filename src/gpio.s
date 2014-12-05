/*
 * General GPIO management code.
 *
 * This file contains basic GPIO code; it currently is used to
 * interact with the ACT/OK LED.
 */

/* GPIO returns the base address for the GPIO controller in r0. */
.globl GPIOAddress
GPIOAddress:
  push {lr}
  ldr  r0, =0x20200000
  pop  {pc}

/*
 * SetGPIOFunction sets the GPIO pin in r0 to the function in r1.
 */
.globl SetGPIOFunction
SetGPIOFunction:
  cmp   r0, #53
  cmpls r1, #7
  movhi pc, lr

  push  {lr}
  mov   r2, r0
  bl    GPIOAddress

fnLoop$:
  cmp   r2, #9
  subhi r2, #10
  addhi r0, #4
  bhi   fnLoop$

  add   r2, r2,lsl #1
  lsl   r1, r2
  str   r1, [r0]

  pop   {pc}

/* 
 * SetGPIO sets the GPIO pin in r0 to be either active or low (via r1).
 *
 * r0 must be 0 <= r0 <= 53
 * r1 must be 0 <= r1 <= 7
 */
.globl SetGPIO
SetGPIO:
  cmp   r0, #53
  movhi pc, lr

  push  {lr}
  mov   r2, r0
  bl    GPIOAddress
  lsr   r3, r2, #5
  lsl   r3, #2
  add   r0, r3
 
  and   r2, #31
  mov   r3, #1
  lsl   r3, r2

  teq   r1, #0
  streq r3, [r0,#40]
  strne r3, [r0,#28]

  pop   {pc}

