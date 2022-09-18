; Escribir un programa que encienda una luz a la vez, de las ocho conectadas al puerto paralelo del
; microprocesador a través de la PIO, en el siguiente orden de bits: 0-1-2-3-4-5-6-7-6-5-4-3-2-1-0-1-2-3-
; 4-5-6-7-6-5-4-3-2-1-0-1-..., es decir, 00000001, 00000010, 00000100, etc. Cada luz debe estar
; encendida durante un segundo. El programa nunca termina.

TIMER EQU 10H
PIC EQU 20H
PIO EQU 30H

ORG 1000H
  IZQ DB 1 ; Variable para saber hacia dónde estoy rotando los bits en cada momento

ORG 3000H
  ; Recibe byte a rotar por valor en CL
  ROTAR_DERECHA:  MOV CH, 7
            LUP:  ADD CL, CL
                  ADC CL, 0
                  DEC CH
                  CMP CH, 0
                  JNZ LUP
                  RET
  ; Recibe byte de estado para actualizar en CL
  ENCENDER_LUCES: PUSH AX
                  CMP IZQ, 1 ; Me fijo para qué lado roto los bits
                  JNZ DER
                  ADD CL, CL
                  ADC CL, 0
                  CMP CL, 10000000b
                  JNZ FIN
                  MOV IZQ, 0
                  JMP FIN
             DER: CALL ROTAR_DERECHA
                  CMP CL, 1
                  JNZ FIN
                  MOV IZQ, 1
             FIN: MOV AL, CL
                  OUT  PIO+1, AL ; Actualizo el PB
                  MOV AL, 20H
                  OUT PIC, AL ; EOI
                  MOV AL, 0
                  OUT TIMER, AL ; RESET TIMER
                  POP AX
                  IRET
ORG 2000h
  ; Configuro PIO
  MOV AL, 0
  OUT PIO+3, AL ; PB como salida
  ; Configuro PIC
  CLI
  MOV AL, 11111101b
  OUT PIC+1, AL ; IMR para atender al timer
  MOV AL, 4
  OUT PIC+5, AL ; Id para buscar en el vector
  MOV BX, 16
  MOV WORD PTR [BX], ENCENDER_LUCES ; Cargo la dir de la subrutina en el vector de int
  MOV AL, 1
  OUT TIMER+1, AL ; COMP TIMER
  MOV AL, 0
  OUT TIMER, AL ; CONT TIMER
  MOV CL, 1 ; Inicializo estado luces
  STI

  LOOP: JMP LOOP

END
