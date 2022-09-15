; Escribir un programa que implemente un conteo regresivo a partir de un valor ingresado desde el teclado. El conteo
; debe comenzar al presionarse la tecla F10. El tiempo transcurrido debe mostrarse en pantalla, actualizándose el valor cada
; segundo.

TIMER EQU 10H
EOI EQU 20H
IMR EQU 21H



ORG 1000H
  mensaje db "Ingrese las dos cifras para el conteo regresivo (max 99seg): "
  fin db ?
  segundos dw ?
  finalizado db 0

ORG 3000H
  INICIAR: MOV AL, 11111101b ; Actualizo la máscara habilitando el timer y deshabilitando el f10
           OUT IMR, AL
           MOV AL, 0
           OUT TIMER, AL ; Reincio el cont del timer
           MOV AL, 20H
           OUT EOI, AL
           IRET

          ; Recibe segundos en BX
  CUENTA: PUSH AX
          CMP segundos+1, 31H; chequeo si me quedan unidades
          DEC segundos+1
          JMP PRINT
 DECENAS: CMP segundos, 31H ; sino chequeo si me quedan decenas
          JS FIN ; si no me queda nada chau
          DEC segundos ; si me queda le saco uno
          MOV segundos+1, 39H ; ya cuento con que substraje y asigno el 9 a las unidades
          JMP PRINT
     FIN: MOV finalizado, 1
   PRINT: MOV AL, 2
          INT 7
          MOV AL, 20H
          OUT EOI, AL
          POP AX
          IRET

ORG 2000H
  CLI
  ; Configuro el PIC
  MOV AL, 11111110b
  OUT IMR, AL
  MOV AL, 4
  OUT 24H, AL ; id f10
  MOV AL, 5
  OUT 25H, AL ; id timer
  MOV AL, 1
  OUT TIMER+1, AL ; seteo el comp del timer en 1 (seg)
  STI
  ; seteo la cuenta regresiva
  MOV BX, OFFSET mensaje
  MOV AL, OFFSET FIN - OFFSET mensaje
  INT 7
  MOV BX, OFFSET segundos
  INT 6
  INC BX
  INT 6


  ; espero a la interrupción f10
  LOOP: CMP finalizado, 1
        JNZ LOOP
  INT 0
END
