program Modelo
   implicit none
   integer N,k,i,m,j, pos1,pos2,estado1, estado2, estado4, estado5,estado3, cont
   integer, allocatable :: configuracion(:,:)
   real *8 r, T, p, tiempo, limite_tiempo,paso, energia


   open(11, file='Resultados.txt',status='unknown') ! Abrimos un archivo para guardar los resultados
   N = 50 !Valor de la cantidad de celdas que habrá será una config. cuadrada
   limite_tiempo = 2500000.0d0! Establecemos un límite de tiempo para la simulación
   tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
   paso = 1.0d0 ! Establecemos el paso de tiempo para la simulación
   cont = 0 ! Inicializamos el contador de iteraciones

   allocate(configuracion(N,N)) ! Reservamos memoria para la configuración del sistema
   call random_seed() ! Inicializamos la semilla de numeros aleatorios

   call random_number(r) ! Generamos un número aleatorio entre 0 y 1
   T = 5.0d0 * r ! Asignamos un valor aleatorio

   !----------------------------------------------------------------------------------------------
   ! Generamos la configuración inicial del sistema.
   !----------------------------------------------------------------------------------------------

   m = 2 !Valor de m para generar números enteros aleatorios entre 1 y
   do i = 1, N
      do j = 1, N
         call random_number(r)
         k = int(m*r) + 1
         if (k == 1) then
            configuracion(i,j) = -1 ! Asignamos el valor -1 a la celda si el número aleatorio es 1
         else
            configuracion(i,j) = 1 ! Asignamos el valor 1 a la celda si el número aleatorio es 2
         end if
      end do
   end do

   do while(tiempo<limite_tiempo)




      !----------------------------------------------------------------------------------------------
      ! Elegimos un número aleatorio para seleccionar una celda del sistema y cambiar su estado.
      !----------------------------------------------------------------------------------------------

      m = N !Valor de m para generar números enteros aleatorios entre 1 y N

      call random_number(r)
      pos1 = int(m*r) + 1

      call random_number(r)
      pos2 = int(m*r) + 1


      !----------------------------------------------------------------------------------------------
      ! Calculamos la energía del sistema antes de cambiar el estado de la celda seleccionada
      !----------------------------------------------------------------------------------------------


      estado1 = configuracion(pos1,pos2) ! Estado de la celda seleccionada
      if (pos1 -1<=0) then
         estado2 = configuracion(N,pos2)
      else
         estado2 = configuracion(pos1-1,pos2)
      end if
      if (pos1 +1 > N) then
         estado3 = configuracion(1,pos2)

      else
         estado3 = configuracion(pos1+1,pos2)
      end if

      if (pos2 -1 <= 0) then
         estado4 = configuracion(pos1,N)
      else
         estado4 = configuracion(pos1,pos2-1)
      end if


      if (pos2 +1 > N) then
         estado5 = configuracion(pos1,1)
      else
         estado5 = configuracion(pos1,pos2+1)
      end if

      energia = 2* estado1 * (estado2 + estado3 + estado4 + estado5) ! Calculamos la energía del sistema antes de cambiar el estado de la celda seleccionada



      p = min(1.0d0, exp(-energia/T)) ! Calculamos la probabilidad de aceptar el cambio de estado de la celda seleccionada

      !----------------------------------------------------------------------------------------------
      ! Decidimos si aceptamos el cambio de estado de la celda seleccionada o no, comparando la probabilidad calculada con un número aleatorio.
      !----------------------------------------------------------------------------------------------
      call random_number(r)
      if (r < p) then
         configuracion(pos1,pos2) = - estado1 ! Cambiamos el estado de la celda seleccionada
      end if

      cont = cont + 1 ! Incrementamos el contador de iteraciones

      if (cont == N*N) then
         write(11,*) configuracion
         write(11,*)
         write(11,*)
         cont = 0
      end if

      tiempo = tiempo+paso

   end do




   close(11) ! Cerramos el archivo de resultados
   deallocate(configuracion) ! Liberamos la memoria reservada para la configuración del sistema

   print*, 'Simulación finalizada. Resultados guardados en "Resultados.txt".'
end program Modelo
