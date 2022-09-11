; Escribir un programa que solicite el ingreso de un número (de un dígito) por teclado y muestre en pantalla dicho
; número expresado en letras. Luego que solicite el ingreso de otro y así sucesivamente. Se debe finalizar la ejecución al
; ingresarse en dos vueltas consecutivas el número cero.
org 1000h
  ; Reservo espacio en memoria para la data de los números
  ; 3 posiciones: 2 para dirección de cadena de nombre y una para len? o calculo luego ya fue
  num0 dw ? ; 1000h
  num1 dw ?
  num2 dw ?
  num3 dw ?
  num4 dw ?
  num5 dw ?
  num6 dw ?
  num7 dw ?
  num8 dw ?
  num9 dw ? ; 1009h
  dir_fin dw ?
  mensaje db "Ingrese un digito numerico: "
  numero db ?

org 1050h
  cero db "cero"
  uno db "uno"
  dos db "dos"
  tres db "tres"
  cuatro db "cuatro"
  cinco db "cinco"
  seis db "seis"
  siete db "siete"
  ocho db "ocho"
  nueve db "nueve"
  fin db ?

org 3000h
  ; configuro el guardado de las direcciones de las cadenas. Capaz se puede presetear de otra forma con el compilador
  CONFIG: mov BX, offset cero
          mov num0, BX
          mov BX, offset uno
          mov num1, BX
          mov BX, offset dos
          mov num2, BX
          mov BX, offset tres
          mov num3, BX
          mov BX, offset cuatro
          mov num4, BX
          mov BX, offset cinco
          mov num5, BX
          mov BX, offset seis
          mov num6, BX
          mov BX, offset siete
          mov num7, BX
          mov BX, offset ocho
          mov num8, BX
          mov BX, offset nueve
          mov num9, BX
          mov BX, offset fin
          mov dir_fin, BX
          ret

  ; Recibe numero por valor en registro DL. Ojo que no deja intactos los registros
  IMPRIMIR_DIG: mov BL, DL
                sub BL, 30H ; resto lo que le "sobra" al num para mapearlo a las primeras posiciones de memoria
                add BL, BL ; multiplico por dos porque son direcciones de palabra
                mov BH, 10H ; completo BX
                mov DX, [BX] ; cargo dirección de memoria de la cadena que representa al dígito
                add BX, 2
                mov AX, [BX] ; traigo la dirección de la siguiente cadena
                sub AX, DX ; calculo la longitud de la cadena, que debería quedar en AL
                mov BX, DX ; traigo a BX la dir de memoria de la cadena original
                int 7 ; imprimo de una vez
                ret

org 2000h
  call CONFIG
  pre_loop: mov CL, 0 ; contador de veces consecutivas que ingresamos 0
  ; imprimo mensaje
  loop: mov BX, offset mensaje
        mov AL, offset numero - offset mensaje
        int 7
        ; leo digito
        mov BX, offset numero
        int 6
        mov DL, numero
        call IMPRIMIR_DIG
        ; me fijo si ingresé 0, sino vuelvo al loop
        cmp numero, 30H
        jnz pre_loop
        inc CL
        cmp CL, 2
        jnz loop
        int 0
end
