; Mostrar en pantalla las letras del abc sin espacios intercalando mayus y minus
; no guardar texto en memoria de datos
; A = 41H, a = 61H;

; asumo que sí puedo guardar caracteres
; Z es 5AH (90d)
org 1000h
 letra1 db 40H
 letra2 db 60H

org 3000h
 impr_inc: inc letra1
           inc letra2
           int 7
           ret
org 2000h
 mov BX, offset letra1
 mov AL, 2
 LAZO: call impr_inc
       cmp letra1, 5AH
       jnz LAZO
 int 0
end
