; Mostrar en pantalla todos los caracteres disponibles en el MSX88 comenzando desde 01H
; Como usa ASCII lo tomo como 8 bits de 0-127
org 1000h
 cadena db ?

org 2000h
 mov CL, 00H
 mov BX, offset cadena
 ; escribo todos los caracteres en memoria
 LAZO: inc CL
       mov [BX], CL
       inc BX
       cmp CL, 127
       jnz LAZO
 ; los imprimo con int 7
 mov AL, CL
 dec AL ; resto el primer caracter que no se usa
 mov BX, offset cadena
 int 7
 int 0
end
