; Escribir un programa que aguarde el ingreso de una clave de cuatro caracteres por teclado sin visualizarla en pantalla. En
; caso de coincidir con una clave predefinida (y guardada en memoria) que muestre el mensaje "Acceso permitido", caso
; contrario el mensaje "Acceso denegado".


org 1000h
  clave_orig db "1f5h"
  clave_usr db ?,?,?,?
  msj_ok db "Aceso permitido"
  msj_fail db "Acceso denegado"
  msj_inicial db "Ingrese los 4 caracteres de su clave: "
  fin_msj_inicial db ?

org 2000h
        mov BX, offset msj_inicial
        mov AL, offset fin_msj_inicial - offset msj_inicial
        int 7
        ; leo los 4 caracteres guardándolos en memoria
        mov BX, offset clave_usr
        mov CL, 4
  loop: int 6
        inc BX
        dec CL
        cmp CL, 0
        jnz loop
        ; compruebo si coinciden con la clave original
        mov BX, offset clave_orig
        mov AX, offset clave_usr
        mov CL, 4 ; o podría calcularse
  comp: cmp CL, 0 ; me fijo si no llegué al final de la comparación
        jz fin_ok
        mov DL, [BX]
        push BX
        mov BX, AX ; dirección clave usuario
        mov DH, [BX]
        pop BX
        inc BX ; me muevo en el vector de caracteres
        inc AX
        dec CL ; actualizo el contador
        cmp DL, DH ; comparo los caracteres
        jz comp
        ; si estamos acá es porque alguna comparación dio que los caracteres no eran iguales
        mov BX, offset msj_fail
        mov AL, offset msj_inicial - offset msj_fail
        int 7
        jmp fin

fin_ok: mov BX, offset msj_ok
        mov AL, offset msj_fail - offset msj_ok
        int 7

   fin: int 0
end
