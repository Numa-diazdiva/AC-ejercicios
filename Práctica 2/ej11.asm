; Programa que imprime en pantalla una letra ("al azar"?) entre la a y la z cuando se presiona f10

A EQU 97
EOI EQU 20H
IMR EQU 21H

org 1000h
  letra db ?

org 3000h
; recibe el código de letra actual por valor en registro CL, ya inicializado en A como mínimo
; recibe la dirección de la variable letra en reg BX
IMPRIMIR_LETRA: INC CL
                CMP CL, 123
                JNZ FIN
                MOV CL, A
          FIN:  MOV [BX], CL
                MOV AL, 1
                INT 7
                MOV AL, 20H
                OUT EOI, AL
                IRET


org 2000h
  ; configuro lo que es el PIC
  MOV AL, 11111110b
  OUT IMR, AL ; configuro la máscara del IMR
  MOV AL, 3
  OUT 24H, AL ; configuro ID
  ; configuro Vector de interrupciones
  MOV AX, IMPRIMIR_LETRA
  MOV BX, 0CH
  MOV [BX], AX
  ; inicializo CL y BX
  MOV CL, 96
  MOV BX, OFFSET letra

  LOOP: JMP LOOP

END
