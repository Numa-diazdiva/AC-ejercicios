; Escribir un programa para imprimir el mensaje “ORGANIZACION Y ARQUITECTURA DE
; COMPUTADORAS” utilizando la impresora a través de la PIO.

; NOTAS: Si no hay loop al final, puede que el procesador termine el programa antes que la impresora termine de Imprimir
; - Si no inicializamos el strobe en 0 y por casualidad estaba en 1, podemos perder la impresión del primer caracter (ocurre con este programa)
PIO EQU 30H

ORG 1000H
  MENSAJE DB "ORGANIZACION Y ARQUITECTURA DE COMPUTADORAS"
  FIN_MSJ DB ?


ORG 2000H
  ; Configuro el PIO
  MOV AL, 11111101b
  OUT PIO+2, AL ; Configuro estado (PA mediante CA) todo como entrada, excepto el bit de strobe
  MOV AL, 0
  OUT PIO+3, AL ; Configuro bus de datos (PB mediante CB) todo como salida para enviar los caracteres.

  MOV BX, OFFSET MENSAJE
  POLL: IN AL, PIO
        AND AL, 1 ; Me importa comparar el bit menos significativo, de manera tal que cuando esté en 0, el and va a dar 0 sí o sí
        JNZ POLL
        ; Imprimimos
        MOV AL, [BX]
        OUT PIO+1, AL
        ; SETEAMOS Y RESETEAMOS STROBE
        IN AL, PIO
        OR AL, 00000010b ; forzamos a 1 el strobe con máscara
        OUT PIO, AL
        IN AL, PIO
        AND AL, 11111101b ; forzamos a 0 el strobe
        OUT PIO, AL
        ; Nos movemos en el string
        INC BX
        CMP BX, OFFSET FIN_MSJ
        JNZ POLL

  INT 0
END
