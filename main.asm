.device attiny45 ; well 44 but close enough
.org 0x0000
;
; This is a dumb program just to test the spiKeyboard
; 
; I'd like to make a neat uart out function tho
; 
;
;
;

; ya im not even doing interrupt vectors
rjmp reset

.include "uartOut.asm"

reset:
  sbi $1a, 7 ; this is my uart pin
  ldi r16, $80
  out $06, r16 ; enable adc

  dedLoop:
  rcall readADC
  rcall formatAndSendData
  rcall plzWait
  rjmp dedLoop

formatAndSendData:
  push r16
  mov r16, r0
  
  swap r0
  rcall hexToAscii ; passing R0
  rcall uartOut
  
  mov r0, r16
  rcall hexToAscii ; passing R0
  rcall uartOut
  
  ldi r16, $20
  mov r0, r16
  rcall uartOut
  pop r16
ret

hexToAscii: ; low nibble only
  push r16
  push r17
	mov r16, r0
	cbr r16, $F0
	ldi r17, $30
	add r16, r17
	cpi r16, $3A
	brlo noNeedToAdd
		ldi r17, $07
		add r16, r17
	noNeedToAdd:
	mov r0, r16
  pop r17
  pop r16
ret


readADC:
  push r16
  ldi r16, $c7 
  out $06, r16
  ldi r16, $10
  out $03, r16
  ldi r16, $01
  out $01, r17
  waitForADC:
    in r16, $06
	cbr r16, $BF
  brne waitForADC
  in r16, $05
  mov r0, r16
  pop r16
ret

plzWait:
  push r16
  push r17
  push r18

  clr r16
  clr r17
  ldi r18, $C0

  plzWaitLoop:
  inc r16
  brne plzWaitLoop
  inc r17
  brne plzWaitLoop
  inc r18
  brne plzWaitLoop

  pop r18
  pop r17
  pop r16
ret


nop
nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

nop
nop
nop
nop

