program LeerDatos
   implicit none
   real*8 vector(0:9), par(0:4),dato, a, b ,c,x
   integer i, j, ios

   open(10,file='Datos.dat', status='unknown')

   do i =0, 9
      read(10,*) vector(i)
   end do

   open(11,file='DatosPar.dat', status='unknown')
   open(12,file='DatosPar2.dat', status='unknown')

   print*, "El vector es: "
   print*, vector

   j=0

   do i = 0, 9
      if (mod(vector(i),2.d0) == 0) then
         par(j) = vector(i)
         j = j + 1
      end if
   end do

   do i = 0, size(par)-1
      write(11,*) par(i)
   end do

   print*, "Los números pares son: "
   print*, par

   do i = 2, size(vector)-1 , 2
      write(12,*) vector(i)
   end do

   close(10)
   close(11)
   close(12)


   open(12,file='DatosPar2.dat', status='old')


   print*, "Los números del archivo DatosPar2.dat son (que corresponde a las posiciones pares del archivo Datos.dat): "
   do
      read(12,*,iostat=ios) dato
      if (ios /= 0) then
         exit
      end if
      print*, dato
   end do

   close(12)

   a = vector(0)
   b = vector(1)
   c = vector(2)

   print*, "La ecuacion cuadrática es: ", a, "x^2 + ", b, "x + ", c, " = 0"
   if (b**2 - 4*a*c < 0) then
      print*, "La ecuación no tiene raíces reales"
   else
      print*, "La ecuación tiene raíces reales"
   end if


   x = 0.d0
   do while(x < 10.2d0)
      !print*, "El valor de x es: ", x
      x = x + 0.1d0
   end do

end program LeerDatos
