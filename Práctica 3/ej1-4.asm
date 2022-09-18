; Escribir un programa que implemente un encendido y apagado sincronizado de las luces. Un contador,
; que inicializa en cero, se incrementa en uno una vez por segundo. Por cada incremento, se muestra a
; través de las luces, prendiendo solo aquellas luces donde el valor de las llaves es 1. Entonces, primero
; se enciende solo la luz de más a la derecha, correspondiente al patrón 00000001. Luego se continúa con
; los patrones 00000010, 00000011, y así sucesivamente. El programa termina al llegar al patrón
; 11111111.


; No tiene mucho sentido lo que dice el enunciado acerca de las llaves. Cómo es que hago si tengo que configurar las llaves como salida y como entrada al mismo tiempo?
; O las reconfiguro en el medio pero para eso vinculo el número del contador directamente con el resultado del encendido de las luces.
; Revisar implementación propuesta

PIO EQU 30H
TIMER EQU 10H
PIC EQU 20H

ORG 1000H
 FIN DB 0

ORG 3000H
; Recibe contador por valor en CL y lo incrementa, actualizando la salida PB con su valor.
; El chequeo de finalización de programa debe hacerse por fuera de la subrutina.
SUBTIMER:    PUSH AX
             CMP CL, 0FFH
             JNZ SEGUIR
             MOV FIN, 1
             JMP FINAL
    SEGUIR:  INC CL
             MOV AL, CL
     FINAL:  OUT PIO+1, AL
             MOV AL, 0
             OUT TIMER, AL ; Reseteo el Timer
             MOV AL, 20H
             OUT PIC, AL ; End Of Interruption
             POP AX
             IRET
ORG 2000H
  ; Configuro el PIO
  MOV AL, 0
  OUT PIO+3, AL ; Configuro PB como salida
  ; Configuro PIC
  CLI
  MOV AL, 11111101b
  OUT PIC+1, AL ; Configuro IMR
  MOV AL, 4
  OUT PIC+5, AL ; Configuro ID para la int 2 -int timer-
  MOV BX, 16
  MOV WORD PTR [BX], SUBTIMER ; Configuro Vector Interrupciones
  ; Config Timer
  MOV AL, 1
  OUT TIMER+1, AL ; Interrumpe cada 1 seg
  MOV CL, 0 ; Contador
  MOV AL, 0
  OUT TIMER, AL ; Inicializo el timer
  STI

  LAZO: CMP FIN, 1
        JNZ LAZO

  INT 0
END
  
