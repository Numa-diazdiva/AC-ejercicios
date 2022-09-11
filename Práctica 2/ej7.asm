; Programa que imprime la suma de dos números ingresados por teclado
; Esta implementación sirve solo para sumar dos dígitos decimales (no números más grandes), ya que su suma siempre da un resultado menor a 20
; *chequear si no hay alguna mejor, más escalable

org 1000h
  num1 db ?
  num2 db ?
  resultado dw ?
  mensaje db "Ingrese dos numeros de 1 digito que desee sumar: "
  fin_mensaje db ?

org 2000h
          mov BX, offset mensaje
          mov AL, offset fin_mensaje - offset mensaje
          int 7
          ; leo dígitos
          mov BX, offset num1
          int 6
          mov BX, offset num2
          int 6
          ; formateo dígitos
          mov AL, num1
          sub AL, 30H
          mov AH, num2
          sub AH, 30H
          add AH, AL
          ; me fijo qué pasó con la cantidad de dígitos del resultadios
          cmp AH, 0AH
          js menor
          sub AH, 0AH ; resto las decenas, que nunca son mayores a 1. Me quedo con el dígito de las unidades
          mov AL, 31H ; reutilizo AH para guardar el número 1 (decena) en ASCII
          jmp fin
  menor:  mov AL, 30H ; guardo 0 para las decenas en número de caracter ASCII
  fin:    add AH, 30H ; convierto las unidades a número de caracter ASCII
          mov resultado, AX
          mov BX, offset resultado
          mov AL, 2
          int 7
          int 0
end
