; Implementar a través de un programa un reloj segundero que muestre en pantalla los segundos transcurridos (00-59 seg)
; desde el inicio de la ejecución.
; en el VonSim falla al ejecutarlo por encima de 8hz

EOI EQU 20H
IMR EQU 21H
CONT EQU 10H
COMP EQU 11H


ORG 1000h
  detener db 0
  char db ?

ORG 3000h
  ; Recibe CL ya inicializado en 0. Recibe dirección de caracter a imprimir en BX
  CONTAR: INC CL
          CMP CL, 59
          JNZ IMP
          MOV detener, 1 ; setear variable detener
     IMP: CALL IMPRIMIR
          MOV AL, 0 ; reset contador
          OUT CONT, AL
          MOV AL, 20H
          OUT EOI, AL
          IRET

  ; Recibe el número en CL y lo imprime como ASCII. Necesita dir de variable en BX
  IMPRIMIR: MOV DL, 0
            MOV DH, CL
   DESCOMP: CMP DH, 10
            JS FIN
            SUB DH, 10
            INC DL ; cuento decenas
            JMP DESCOMP
       FIN: ADD DL, 30H ; lo vuelvo ASCII
            MOV [BX], DL
            MOV AL, 1
            INT 7 ; imprimo decenas
            ADD DH, 30H
            MOV [BX], DH
            INT 7 ; imprimo unidades
            RET

ORG 2000h
  ; Configuramos el PIC
  CLI
  MOV AL, 11111101b ; máscara del IMR, solo el Timer
  OUT IMR, AL
  ; Configuramos ID para timer
  MOV AL, 5
  OUT 25H, AL
  ; Configuramos Vector Interrupciones
  MOV AX, CONTAR
  MOV BX, 14H
  MOV [BX], AX
  ; Configuramos el comparador del Timer
  MOV AL, 1
  OUT COMP, AL
  STI
  ; Mando el BX como parámetro
  MOV BX, offset char
  MOV CL, 0

  MOV AL, 0
  OUT CONT, AL

  LOOP: CMP detener, 0
        JZ LOOP
END
