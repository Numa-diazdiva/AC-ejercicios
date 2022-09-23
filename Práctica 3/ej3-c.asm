; Imprimir "UNIVERSIDAD NACIONAL DE LA PLATA" por interrupciones mediante handshake
; Con este algoritmo tenemos el problema de que se pasa de largo la impresora por ser muy rápida.
; También tenemos el problema de que si quedó lleno el buffer y llegamos al final del string con bx, terminamos sin haber impreso todo.

HANDSHAKE EQU 40H
PIC EQU 20H

ORG 1000H
mensaje DB "UNIVERSIDAD NACIONAL DE LA PLATA"
fin DB ?

ORG 3000H
          ; recibe la dirección del caracter a imprimir por BX
IMPRIMIR: PUSH AX ; Por seguridad para no cagarla
          MOV AL, [BX]
          OUT HANDSHAKE, AL ; Mando el caracter al puerto de datos del Handshake
          INC BX
          MOV AL, 20H
          OUT PIC, AL ; Aviso al EOI que terminó la interrupción
          POP AX
          IRET

ORG 2000H
; Configuro el PIC
CLI
MOV AL, 11111011b
OUT PIC+1, AL ; Le mando al IMR la config para habilitar el INT2
MOV AL, 4
OUT PIC+6, AL ; Pongo el ID 4 en la celda de INT2 (Handshake)
MOV BX, 16
MOV WORD PTR [BX], IMPRIMIR
; Configuro el Handshake
IN AL, HANDSHAKE+1 ; Me traigo el estado
OR AL, 10000000b ; Fuerzo a 1 el bit de las interrupciones
OUT HANDSHAKE+1, AL
; Pongo el dato que necesita la subrutina en BX
MOV BX, OFFSET mensaje
STI
LOOP: CMP BX, OFFSET fin
      JNZ LOOP ; loopeo mientras no se haya acabado el mensaje

; Le saco al Handshake la capacidad de interrumpir
IN AL, HANDSHAKE+1
AND AL, 01111111b
OUT HANDSHAKE+1, AL
INT 0
END
