; Escribir un programa que solicite ingresar caracteres por teclado y que recién al presionar la tecla F10
; los envíe a la impresora a través de la PIO. No es necesario mostrar los caracteres en la pantalla.

PIC EQU 20H
PIO EQU 30H

ORG 40
  SUB_10 DW IMPRIMIR ; Pongo dir de subrutina imprimir en el vector de interrupciones, ID 10

ORG 1000H
 MSJ DB "Ingrese caracteres. Para imprimir presione f10"
 CARACTERES DB ?
 IMPRIMI DB 0

ORG 3000H
  ; Recibe la dirección del último caracter en BX y la del primer caracter en DX
  IMPRIMIR: PUSH AX ; Ver si no pushear más registros
            MOV CX, BX
            SUB CX, DX ; Dejo en CX la cant de caracteres a imprimir
            MOV BX, DX ; Dejo en BX la dir del primer caracter
      POLL: IN AL, PIO
            AND AL, 1
            JNZ POLL
            MOV AL, [BX]
            OUT PIO+1, AL ; Mando el caracter a la impresora
            ; Strobe 1
            IN AL, PIO
            OR AL, 00000010b
            OUT PIO, AL
            ; Strobe 0
            IN AL, PIO
            AND AL, 11111101b
            OUT PIO, AL
            INC BX
            DEC CX
            JNZ POLL
            ; EOI
            MOV IMPRIMI, 1
            MOV AL, 20H
            OUT PIC, AL
            POP AX
            IRET

ORG 2000H
  MOV AL, 11111101b
  OUT PIO+2, AL ; Configuro Estado CA
  MOV AL, 0
  OUT PIO+3, AL ; Configuro puerto de datos mediante CB
  IN AL, PIO
  AND AL, 11111101b
  OUT PIO, AL ; Inicializo el strobe en 0

  ; Configuro PIC
  CLI
  MOV AL, 11111110b ; Quiero que me interrupa F10 (INT0)
  OUT PIC+1, AL ; Seteo IMR
  MOV AL, 10
  OUT PIC+4, AL ; Pongo en INT0 el ID 10
  STI

  ;Imprimo instrucción
  MOV BX, OFFSET MSJ
  MOV AL, OFFSET CARACTERES - OFFSET MENSAJE
  INT 7
  MOV DX, OFFSET CARACTERES
  MOV BX, OFFSET CARACTERES
  LOOP: CMP IMPRIMI, 1
        JZ FIN
        INT 6
        INC BX
        JMP LOOP

  FIN: INT 0
END
