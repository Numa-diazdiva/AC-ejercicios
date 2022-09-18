; Escribir un programa que verifique si la llave de más a la izquierda está prendida. Si es así, mostrar en
; pantalla el mensaje “Llave prendida”, y de lo contrario mostrar “Llave apagada”. Solo importa el valor
; de la llave de más a la izquierda (bit más significativo). Recordar que las llaves se manejan con las
; teclas 0-7.

; Algoritmo:
; Configuro PIO
; Loopeo esperando a ver qué pasa. O no loopeo nada y que el programa corra una vez y se fije en qué estado estaba la cosa


PIO EQU 30H

ORG 1000h
  msj_on db "Llave encendida"
  msj_off db "Llave apagada"
  msj_fin db ?
ORG 2000H
          MOV AL, 11111111b
          OUT PIO + 2, AL ; Configuro todas las llaves como entrada
          IN AL, PIO
          OR AL, 01111111b; Fuerzo a 1 todos los bits que no son el 7. Con máscara OR + 0, el primer bit va a ser inmutable.
          ; Me puedo fijar los flags de alguna manera? o comparo antes?
          CMP AL, 0FFH ; Comparo por las dudas
          JNZ APAGADA
          MOV BX, OFFSET msj_on
          MOV AL, OFFSET msj_off - OFFSET msj_on
          JMP FIN
APAGADA:  MOV BX, OFFSET msj_off
          MOV AL, OFFSET msj_fin - OFFSET msj_off

FIN:      INT 7
          INT 0
END
