; Escribir un programa que solicita el ingreso de cinco caracteres por teclado y los envía de a uno por
; vez a la impresora a través de la PIO a medida que se van ingresando. No es necesario mostrar los
; caracteres en la pantalla.

; Consultar tema del polling al final para que termine de imprimir si el procesador ya terminó

PIO EQU 30H

ORG 1000H
  CARACTERES DB ?,?,?,?,?
  FIN DB ?
ORG 2000H
  ; Configuro PIO
  MOV AL, 11111101b ; Strobe en salida
  OUT AL, PIO+2
  MOV AL, 0
  OUT AL, PIO+3
  ; Voy a hacer el preseteo del strobe por las dudas
  IN AL, PIO
  AND AL, 11111101b ; fuerzo a 0 el bit de strobe
  OUT PIO, AL
  ; Ahora arranco con el ingreso-impresión
  MOV BX, OFFSET CARACTERES
  POLL: IN AL, PIO
        AND AL, 1
        JNZ POLL ; Espero mientras la impresora esté ocupada
        INT 6
        MOV AL, [BX]
        OUT PIO+1, AL ; Mando el caracter leído al bus de datos PB
        IN AL, PIO
        OR AL, 00000010b ; Fuerzo strobe a 1
        OUT PIO, AL ; Escribo estado PIO
        IN AL, PIO
        AND AL, 11111101b ; Fuerzo strobe a 0
        OUT PIO, AL ; Escribo estado PIO
        INC BX
        CMP BX, OFFSET FIN
        JNZ POLL
  INT 0
END
