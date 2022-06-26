;
;
; This is intended to be a nice uart subroutine that can be reused
; ; sends whatever is in r0
; parity is not supported :(
;
;
; edit the 4 below parameters for custom config
; there are a required minimum number of cycles required per bit
.define baudRate 600
.define clockRate 12000000
.define uartRegister $1b
.define uartPin 7
;
;
.define cyclesPerBit (clockRate / baudRate)

uartOut:  
  push r16
  push r17
  push r18
  push r19
  push r20

  mov r16, r0 ; r0 has limited operations

  in r17, uartRegister
  cbr r17, (1 << uartPin)

  clr r18
  out uartRegister, r17
  uartBitLoop:
    cpi r18, $20
	brsh endUartBitLoop

    clr r19
    clr r20
    uartbitDelayLoop:    ; delay first for start bit reasons
      inc r20
      cpi r20, ((cyclesPerBit / 4) % 256)
        brne uartBitDelayLoop
	    inc r19
        cpi r19, (cyclesPerBit / 4 / 256 + 1)
	    brne uartBitDelayLoop

	  cbr r17, (1 << uartPin)
	  sbrc r16, 0
	    sbr r17, (1 << uartPin)

      lsr r16     ; that's how we rol
	  sbr r16, $80  ; for stop bits

      out uartRegister, r17 ; sending it

	  inc r18
    rjmp uartBitLoop
  endUartBitLoop:

  pop r20
  pop r19
  pop r18
  pop r17
  pop r16
ret
