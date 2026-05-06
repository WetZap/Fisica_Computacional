program Funcion
   implicit none
   real*8 :: x, y, valor ,valor2, z
   real*8,external :: suma ,media

   x = 4.d0
   y = 3.d0
   z = 2.d0

   print*, "El valor de x + y es: ", x + y
   valor = suma(x,y)
   print*, "El valor de x + y es: ", valor

   print*, "El valor de la media de x, y, z es: ", media(x,y,z)




end program Funcion

function suma(x,y) result(valor)
   implicit none
   real*8 x, y, valor
   valor = x + y
end function suma


function media(x,y,z) result(valor)
   implicit none
   real*8 x, y, z, valor
   valor = (x + y + z)/3.d0
end function media

!Otra forma del profesor
!real*8 function suma(x,y)
!real*8 x, y
!suma = x + y
!return
!end function suma



