; Programa que lea 5 caracteres por teclado y los imprima primero en el orden que fueron ingresados y luego al revés, usando la
; impresora por handshake sin interrupciones.

HANDSHAKE EQU 40H

ORG 1000H
  caracteres DB ?,?,?,?,?
  car_fin DB ?
ORG 2000H
  ; Configuro
  IN AL, HANDSHAKE+1 ; Traigo estado
  AND AL, 01111111b ; Fuerzo a 0 el bit de interrumpir
  OUT HANDSHAKE+1, AL
  ; Leo Caracteres
  MOV BX, OFFSET caracteres
  LOOP: INT 6
        INC BX
        CMP BX, OFFSET car_fin
        JNZ LOOP
  ; Imprimo parriba
  MOV BX, OFFSET caracteres
  MOV CL, OFFSET car_fin - OFFSET caracteres
  POLL1: IN AL, HANDSHAKE+1
         AND AL, 1
         JNZ POLL1
         MOV AL, [BX]
         OUT HANDSHAKE, AL
         DEC CL
         INC BX
         CMP CL, 0
         JNZ POLL1
         ; Segunda vuelta imprimo para atrás
         DEC BX
         MOV CL, 5
  POLL2: IN AL, HANDSHAKE+1
         AND AL, 1
         JNZ POLL2
         MOV AL, [BX]
         OUT HANDSHAKE, AL
         DEC CL
         DEC BX
         CMP CL, 0
         JNZ POLL2
  INT 0
END
