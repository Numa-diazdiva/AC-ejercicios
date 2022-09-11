; Escribir un programa que solicite el ingreso de un número (de un dígito) por teclado e inmediatamente lo muestre en la
; pantalla de comandos, haciendo uso de las interrupciones por software INT 6 e INT 7.

org 1000h
 caracter db ?
 mensaje db "Por favor, ingrese un num de un digito: "
 fin db ?
org 2000h
 mov BX, offset mensaje
 mov AL, offset fin - offset mensaje
 int 7
 mov BX, offset caracter
 int 6
 mov AL, 1
 int 7
 int 0
end
 
