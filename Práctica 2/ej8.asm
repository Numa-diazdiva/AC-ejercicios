; Programa que imprime la suma de dos números ingresados por teclado
; Esta implementación sirve solo para sumar dos dígitos decimales (no números más grandes), ya que su suma siempre da un resultado menor a 20
; *chequear si no hay alguna mejor, más escalable

org 1000h
  num1 db ?
  num2 db ?
  resultado db ?
  signo db "-"
  mensaje db "Ingrese dos numeros de 1 digito que desee restar: "
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
          mov DL, num1
          sub DL, 30H
          mov DH, num2
          sub DH, 30H
          sub DL, DH
          ; me fijo qué pasó con la resta
          jns positivo
          mov BX, offset signo
          mov AL, 1
          int 7 ; imprimo el signo si es negativo
          mov DL, not DL
          inc DL ; paso de Ca2 a módulo
positivo: add DL, 30H ; paso el resultado a char ASCII
          mov resultado, DL
          mov AL, 1 ; podría no repetirse
          mov BX, offset resultado
          int 7
          int 0
end
