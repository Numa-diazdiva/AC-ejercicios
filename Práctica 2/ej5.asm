; Agregar al programa anterior la subrutina ES_NUM que verifique si el caracter ingresado es un num
; Si el caracter no es un num imprimir "CARACTER NO VALIDO"
; La subrutina debe recibir el código del caracter por referencia desde el programa principal y debe devolver vía registro
; el valor 0FFH en caso de tratarse de un número o el valor 00H en caso contrario.
; Tener en cuenta que el código del “0” es 30H y el del “9” es 39H.

org 1000h
 caracter db ?
 mensaje db "Por favor, ingrese un num de un digito: "
 fin_mensaje db ? ; esto por ahí no es necesario, se puede usar el offset de inválido, pero queda más claro así
 invalido db "Caracter no valido"
 fin_invalido db ?
 
org 3000h
  ES_NUM: mov DL, [BX]
          cmp DL, 30H
          js no_es
          cmp DL, 3AH ; lo comparo con uno más grande
          jns no_es ; si no hay flag de signo es porque es mayor a 39H y está fuera de rango
          mov CL, 0FFH
          no_es: mov CL, 00H
          ret

org 2000h
 mov BX, offset mensaje
 mov AL, offset fin_mensaje - offset mensaje
 int 7
 mov BX, offset caracter
 int 6
 mov AL, 1
 int 7
 ; llamamos a subrutina que verifica: va caracter por referencia en BX
 call ES_NUM
 ; nos devolvió el resultado por valor en registro CL
 cmp CL, 0FFH
 jz fin
 mov BX, offset invalido
 mov AL, offset fin_invalido - invalido
 fin: int 0
end
