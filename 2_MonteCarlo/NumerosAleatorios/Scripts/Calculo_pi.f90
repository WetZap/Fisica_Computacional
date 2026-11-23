program Pi
   implicit none
   integer*8 i, n,contador
   real*8 x,y




   call random_seed() ! Inicializamos la semilla del generador de números aleatorios
   n =1000000000
   contador = 0

   do i = 1, n
      call random_number(x) ! Generamos un número aleatorio entre 0 y 1 para x
      call random_number(y) ! Generamos un número aleatorio entre 0 y 1 para y
      if ((x)**2 + (y)**2 <= 1.0d0) then ! Verificamos si el punto (x,y) está dentro del cuarto de círculo
         contador = contador + 1 ! Si está dentro, incrementamos el contador
      end if
   end do

   print*, "El numero pi es:" ,(4.d0* contador)/n






end program Pi
