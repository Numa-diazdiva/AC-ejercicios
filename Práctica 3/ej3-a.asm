; Programa que imprime el mensaje "INGENIERIA E INFORMÁTICA" a través de la impresora comunicada por HANDSHAKE
; y haciendo polling.

HANDSHAKE EQU 40H ; 40H datos, 41H estado

ORG 1000H
mensaje DB "INGENIERIA E INFORMATICA"
fin DB ?
ORG 2000H
; Configuramos el Estado del handshake
IN AL, HANDSHAKE+1 ; Nos traemos el estado existente
AND AL, 01111111b ; forzamos el primer bit a 0 para que el handshake no interrumpa, sin alterar el resto de los bits
OUT HANDSHAKE+1, AL
; Me traigo el mensaje
MOV BX, OFFSET mensaje
MOV CL, OFFSET fin - OFFSET mensaje
POLLINGS: IN AL, HANDSHAKE+1 ; Traemos el estado para consultar el bit de Busy
          AND AL, 00000001b ; (lo que es lo mismo que 1, pero para que se vea más clara la máscara)
          JNZ POLLINGS ; el primer bit es el que determina si da 0 o no
          MOV AL, [BX]
          OUT HANDSHAKE, AL
          INC BX
          DEC CL ; Se puede hacer comparando bx con el offset de fin también
          JNZ POLLINGS
INT 0
END
