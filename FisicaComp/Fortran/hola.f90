program hola
   implicit none
   real*8 x, pi, y(0:20), z(0:4) , w(0:4), m(0:4,0:4)
   integer i
   x =3.d0
   pi = 4.d0*atan(1.d0)
   ! La función datan devuelve el arcotangente de su argumento, por lo que datan(1) es igual a pi/4, y al multiplicarlo por 4 obtenemos el valor de pi. Si pusiesemos atan(1.d0)


   open(10, file="raiz.dat", status="unknown")

   print*,"Hola Mundo"

   print*,"El valor de x es: ", x
   print*,"El valor de pi es: ", pi

   do i=0,100
      !       print*, "Valores i           , x            y=sqrt(x)       y = x^3: "
      !       print*, i, (i*1.d0)/10 ,sqrt((i*1.d0)/10) ,((i*1.d0)/10)**3
      write(10,*) (i*1.d0)/10 ,sqrt((i*1.d0)/10), ((i*1.d0)/10)**3
   end do


   do i = 0,20
      y(i)=dsqrt(i*0.1d0)
      print*, y(i)
   end do
   close(10)

   print*,y
   print* ,"******"

   print*, (y(i) ,i = 0,3)


   open(10, file="raiz.dat", status="unknown")
   print*,"Leyendo el archivo raiz.dat"
   do i = 0,4
      !read(10,*) z(i) ,w(i)
      read(10,*) m(i,0:4)
      !print*, z(i) ,w(i)
      print*, "Matriz" ,m(i,0:4)
   end do
   close(10)




end program hola

