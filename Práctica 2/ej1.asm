; mostrar mensaje almacenado previamente en memoria de datos
; usar int 7

org 1000h
 mensaje db "Que hace Pablito vamo a jugar un age"
 fin db ?

org 2000h
 mov BX, offset mensaje
 mov AL, offset fin - offset mensaje
 int 7
 int 0
end
