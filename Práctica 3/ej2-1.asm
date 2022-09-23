; Imprimir la letra A usando la impresora a través del PIO
; NOTAS:
; PA se usa para el estado de la impresora (bidireccional) --> BIT 0: BUSY, BIT1: STROBE(te dejé algo para que imprimas). Los otros de entrada para evitar mandar cosas por error
; PB se usa para el puerto de datos de la impresora


PIO EQU 30H

ORG 2000H
  ; Configuro PIO
  MOV AL, 11111101b
  OUT PIO+2, AL ; CA
  MOV AL, 0
  OUT PIO+3, AL ; CB - Todos salida
  ; Ahora voy a imprimir
  IN AL, PIO
  AND AL, 11111101b ; fuerzo a 0 el bit de strobe para arrancar (checar esto)
  OUT PIO, AL
  POLL: IN AL, PIO
        AND AL, 1 ; Me fijo si está strobe en 0 y bussy en 1
        JNZ POLL
  MOV AL, 97
  OUT PIO+1, AL ; Cargo caracter en puerto de datos
  IN AL, PIO
  OR AL, 00000010b ; Fuerzo strobe a 1
  OUT PIO, AL
  INT 0
END
