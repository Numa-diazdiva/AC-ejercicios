; Implementar un reloj similar al utilizado en los partidos de básquet, que arranque y detenga su marcha al presionar
; sucesivas veces la tecla F10 y que finalice el conteo al alcanzar los 30 segundos.

TIMER EQU 10H
EOI EQU 20H
IMR EQU 21H

ORG 1000H
  SEGUNDOS DB 30H, 30H
  INTERRUPTOR DB 1
  TIMER_CURRENT DB ?

ORG 3000H
  TOGGLE: PUSH AX
          CLI
          CMP INTERRUPTOR, 1
          JNZ ENCENDER
          MOV INTERRUPTOR, 0
          IN AL, TIMER
          MOV TIMER_CURRENT, AL
          MOV AL, 11111110b
          OUT IMR, AL
          JMP FIN
ENCENDER: MOV INTERRUPTOR, 1
          MOV AL, 11111100b
          OUT IMR, AL
          MOV AL, TIMER_CURRENT
          OUT TIMER, AL
    FIN:  STI
          MOV AL, 20H
          OUT EOI, AL
          POP AX
          IRET

  ; Debe recibir la dir de SEGUNDOS en BX y la cant a imprimir en AL
  ; ver de reemplazar nombre de variable por puntero en BX para hacer más reutilizable la subrutina
  CONTAR: PUSH AX
          INC SEGUNDOS+1
          CMP SEGUNDOS+1, 3AH
          JNZ RESET
          MOV SEGUNDOS+1, 30H
          INC SEGUNDOS
          CMP SEGUNDOS, 33H
          JNZ RESET
          MOV SEGUNDOS, 30H
   RESET: INT 7
          MOV AL, 0
          OUT TIMER, AL
          MOV AL, 20H
          OUT EOI, AL
          POP AX
          IRET

ORG 2000H
  CLI
    ; Configuro el PIC
    MOV AL, 11111100b
    OUT IMR, AL
    ; INT0 e INT1
    MOV AL, 10
    OUT 24H, AL
    MOV AL, 4
    OUT 25H, AL
    ; Vector de Interrupciones
    MOV BX, 28H ; id 10
    MOV WORD PTR [BX], TOGGLE
    MOV BX, 0F0H
    MOV WORD PTR [BX], CONTAR
    ; Timer
    MOV AL, 1
    OUT TIMER+1, AL ; COMP
    MOV AL, 0
    OUT TIMER, AL ; CONT
    ; Para la subrutina
    MOV AL, 2
    MOV BX, OFFSET SEGUNDOS
  STI

  LOOP: CMP SEGUNDOS, 33H
        JNZ LOOP
  INT 0
END
