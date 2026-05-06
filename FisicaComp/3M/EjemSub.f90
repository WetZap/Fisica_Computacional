program Subroutine
   implicit none
   real*8  x, y, suma, mult, exp
   ! Una subrutina no necesita estar definida en el programa principal, sino que no necesita tener una variable en el principal.

   x = 2.d0
   y = 4.d0

   call operaciones(x,y,suma,mult,exp)
   print*, "El valor de la suma es: ", suma
   print*, "El valor de la multiplicacion es: ", mult
   print*, "El valor de la potencia es: ", exp




end program Subroutine

subroutine operaciones(x,y,suma, mult, exp)
   implicit none
   real*8 x, y, resultado, suma, mult, exp
   suma = x + y
   mult = x * y
   exp = x ** y
   return
end subroutine operaciones
