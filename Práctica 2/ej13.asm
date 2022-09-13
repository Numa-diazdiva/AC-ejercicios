; Modificar el programa anterior para que también cuente minutos (00:00 - 59:59), pero que actualice la visualización en
; pantalla cada 10 segundos.

TIMER EQU 10
PIC EQU 20H
EOI EQU 20H
N_CLK EQU 10

ORG 40
  ; guarda la dir de la subrutina en la pos para el id 10 del vector de interrupciones
  IP_CLK DW RUT_CLK

ORG 1000H
SEG DB 30H, 30H, 3AH, 30H, 30H
FIN DB ?

; Checar modularización y la posibilidad de usar el registro CONT del timer para setear valores
ORG 3000H
RUT_CLK: PUSH AX
         ADD SEG+4, 10
         CMP SEG+4, 3AH
         JNZ RESET
         MOV SEG+4, 30H
         INC SEG+3
         CMP SEG+3, 36H
         JNZ RESET
         MOV SEG+3, 30H
         INC SEG+1
         CMP SEG+1, 3AH
         JNZ RESET
         MOV SEG+1, 30H
         INC SEG
         CMP SEG, 36H
         JNZ RESET
         MOV SEG, 30H
RESET:   INT 7
         MOV AL, 0
         OUT TIMER, AL
         MOV AL, EOI
         OUT PIC, AL
         POP AX
         IRET
ORG 2000H
      CLI
      MOV AL, 0FDH
      OUT PIC+1, AL ; PIC: registro IMR
      MOV AL, N_CLK
      OUT PIC+5, AL ; PIC: registro INT1 SETEA ID
      MOV AL, 10
      OUT TIMER+1, AL ; TIMER: Esta vez mandamos 10 para que compare
      MOV AL, 0
      OUT TIMER, AL ; TIMER: registro CONT
      MOV BX, OFFSET SEG
      MOV AL, OFFSET FIN-OFFSET SEG
      STI
LAZO: JMP LAZO
END
