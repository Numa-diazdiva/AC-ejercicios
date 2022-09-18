; Escribir un programa que permite encender y apagar las luces mediante las llaves. El programa no
; deberá terminar nunca, y continuamente revisar el estado de las llaves, y actualizar de forma
; consecuente el estado de las luces. La actualización se realiza simplemente prendiendo la luz i si la llave
; i correspondiente está encendida (valor 1), y apagándola en caso contrario. Por ejemplo, si solo la
; primera llave está encendida, entonces solo la primera luz se debe quedar encendida


PIO EQU 30H

ORG 2000H

MOV AL, 11111111b
OUT PIO + 2, AL ; Configuro llaves como entrada
MOV AL, 00000000b
OUT PIO + 3, AL ; Configuro las luces como salida

LOOP: IN AL, PIO
      OUT PIO + 1, AL
      JMP LOOP

END
