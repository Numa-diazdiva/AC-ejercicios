; Idem ejercicio anterior pero con interrupciones por PIC
PIC EQU 20H
HANDSHAKE EQU 40H

ORG 1000H
  caracteres DB ?,?,?,?,?
  car_fin DB 0
  dir DB 0

ORG 3000H
  IMPRIMIR: PUSH AX
            MOV AL, [BX]
            OUT HANDSHAKE, AL
            CMP dir, 1
            JNZ adelante
            DEC BX
            JMP fin
  adelante: INC BX
       fin: DEC CL
            MOV AL, 20H
            OUT PIC, AL ; EOI
            POP AX
            IRET

ORG 2000H
              ; Configuro PIC
              CLI
              MOV AL, 11111011b
              OUT PIC+1, AL ; Habilito la interrupción del handshake en el IMR
              MOV AL, 4
              OUT PIC+6, AL ; Asigno ID al Handshake
              MOV BX, 16
              MOV WORD PTR [BX], IMPRIMIR ; Pongo la subrutina deseada en el vector de interrupciones en la pos correspondiente al ID 4
              STI
              ; Leo Caracteres
              MOV BX, OFFSET caracteres
        LEER: INT 6
              INC BX
              CMP BX, OFFSET car_fin
              JNZ LEER
              ; Pongo el dato a imprimir en BX para la subrutina IMPRIMIR
              MOV BX, OFFSET caracteres
              MOV CL, OFFSET car_fin - OFFSET caracteres
              ; Configuro Handshake
              IN AL, HANDSHAKE+1 ; Traigo estado
              OR AL, 10000000b ; Fuerzo a 1 el bit de interrumpir
              OUT HANDSHAKE+1, AL


        LOOP: CMP CL, 0
              JNZ LOOP
              CMP dir, 1
              JZ FIN_IMPRIMIR
              MOV CL, OFFSET car_fin - OFFSET caracteres
              INC dir
              JMP LOOP
FIN_IMPRIMIR: IN AL, HANDSHAKE+1
              AND AL, 01111111b
              OUT HANDSHAKE+1, AL
              INT 0
END



  ;
