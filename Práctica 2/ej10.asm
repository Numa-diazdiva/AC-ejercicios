; Interrupciones por hardware
; Escribir un programa que, mientras ejecuta un lazo infinito, cuente el número de veces que se presiona la tecla F10
; y acumule este valor en el registro DX.

; La cpu corre mucho más rápido que el resto de los dispositivos, por lo que lo más eficiente es que éstos le interrumpan al cpu y así evitar que les espere
; Interrumpen a través de la PIC, disparando la INTn.
; Usamos el vector de interrupciones (0000H - 0400H) para asociar las interrupciones con las subrutinas que ejecutan.

EOI EQU 20H
IMR EQU 21H

org 3000h
  ; subrutina para atender la interrupción
  CONTAR: INC DL
          MOV AL, 20H
          OUT EOI, AL ; Le indico al PIC que terminé mediante su registro EOI
          IRET

org 2000h
      MOV DL, 0
      MOV AX, CONTAR
      MOV BX, 16 ; dirección del id 4 en el vector de Interrupciones
      MOV [BX], AX
      ; configuro lo que se conoce como PIC
      CLI
      MOV AL, 11111110b
      OUT IMR, AL ; configuramos el IMR del PIC
      MOV AL, 4
      OUT 24H, AL ; le asigno un ID  a la interrupción 0 (F10)
      STI

LOOP: JMP LOOP

END
