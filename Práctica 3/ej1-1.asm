; Escribir un programa que encienda las luces con el patrón 11000011, o sea, solo las primeras y las
; últimas dos luces deben prenderse, y el resto deben apagarse.

PIO EQU 30H ; PA 30H, PB, 31H, CA 32H, CB 33H


ORG 1000h

ORG 2000h

  MOV AL, 00000000b
  OUT PIO + 3, AL ; Configuro todos los bits del PB como salida
  MOV AL, 11000011b
  OUT PIO + 1, AL
  INT 0
END
