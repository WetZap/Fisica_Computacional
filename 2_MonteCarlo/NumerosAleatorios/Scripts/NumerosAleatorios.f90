program Aleatorios
   implicit none
   integer i,n,k,m
   real*8 r,suma,suma_cuad,suma_int, suma_int_cuad

   call random_seed() ! Inicializamos la semilla del generador de números aleatorios


   n= 10000
   suma = 0.0d0
   suma_cuad = 0.0d0

   do i = 1, n
      call random_number(r) ! Generamos un número aleatorio entre 0 y 1
      suma = suma + r
      suma_cuad = suma_cuad + r**2
   end do

   write(*,*) "La media de los números aleatorios generados es: ", suma/n
   write(*,*) "El segundo momento de los números aleatorios generados es: ", suma_cuad/n

   write(*,*) "Numeros aleatorios enteros entre 1 y m"







   ! Numeros enteros aleatorios enteros entre 1 y m
   m = 5
   suma_int = 0.0d0
   suma_int_cuad = 0.0d0
   do i = 1 ,n
      call random_number(r) ! Generamos un número aleatorio entre 0 y 1
      k = int(m*r) + 1 ! Convertimos el número aleatorio a un entero entre 1 y m
      suma_int = suma_int + k
      suma_int_cuad = suma_int_cuad + k**2
   end do
   write(*,*) "La media de los números aleatorios generados es: ", suma_int/n
   write(*,*) "El segundo momento de los números aleatorios generados es: ", suma_int_cuad/n

end program Aleatorios
