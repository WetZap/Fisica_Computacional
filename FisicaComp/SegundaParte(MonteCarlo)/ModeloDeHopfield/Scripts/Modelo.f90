program Modelo
   implicit none
   integer N,k,i,m,j, pos1,pos2,estado1, estado2, estado4, estado5,estado3, cont, iteraciones
   integer, allocatable :: configuracion(:,:)
   real *8 r, T, p, tiempo, limite_tiempo,paso, energia, magnetizacion, energia_promedio
   character(len=50) :: nombre_archivo_total, nombre_archivo_energia, valor_j,linea


   N = 50 !Valor de la cantidad de celdas que habrá será una config. cuadrada
   limite_tiempo = 2500000.0d0! Establecemos un límite de tiempo para la simulación
   tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
   paso = 1.0d0 ! Establecemos el paso de tiempo para la simulación
   cont = 0 ! Inicializamos el contador de iteraciones

   allocate(configuracion(N,N)) ! Reservamos memoria para la configuración del sistema
   call random_seed() ! Inicializamos la semilla de numeros aleatorios

   open(12, file="..//Data/Datos/Temperaturas.dat",status='unknown') ! Abrimos un archivo para guardar los resultados
   open(13, file="..//Data/Datos/Magnetizaciones.dat",status='unknown') ! Abrimos un archivo para guardar los resultados
   open(14, file="..//Data/Datos/Energia.dat",status='unknown') ! Abrimos un archivo para guardar los resultados

   !----------------------------------------------------------------------------------------------
   ! Generamos la configuración inicial del sistema.
   !----------------------------------------------------------------------------------------------
   do iteraciones = 1, 30

      call random_number(r) ! Generamos un número aleatorio entre 0 y 1
      T = 5.0d0 * r ! Asignamos un valor aleatorio
      tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
      cont = 0 ! Inicializamos el contador de iteraciones
      energia_promedio = 0.0d0 ! Inicializamos la energía promedio del sistema
      magnetizacion = 0.0d0 ! Inicializamos la magnetización del sistema
      write(12,*) T ! Guardamos la temperatura utilizada en cada simulación


      write(valor_j, '(I10)') iteraciones

      ! Definimos los nombres de los archivos que guardaremos
      nombre_archivo_total = '..//Data/Datos/datos'//trim(adjustl(valor_j))//'.dat'

      open(11, file=nombre_archivo_total,status='unknown') ! Abrimos un archivo para guardar los resultados


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

         if (tiempo + 2*paso > limite_tiempo) then
            do i = 1, N
               do j = 1, N
                  magnetizacion = magnetizacion + configuracion(i,j) ! Calculamos la magnetización del sistema
                  energia_promedio = energia_promedio - configuracion(i,j)
               end do
            end do
            magnetizacion = magnetizacion / (N*N) ! Normalizamos la magnetización
            energia_promedio = energia_promedio / (N*N) ! Normalizamos la energía promedio
         end if


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

         ! Ponemos condiciones periodicas.
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
      write(13,*) abs(magnetizacion)    ! Guardamos la magnetización del sistema en cada simulación

      write(14,*) energia_promedio ! Guardamos la energía del sistema en cada simulación
      write(14,*)
      write(14,*)



   end do


   deallocate(configuracion) ! Liberamos la memoria reservada para la configuración del sistema

   close(12) ! Cerramos el archivo de temperaturas
   close(13) ! Cerramos el archivo de magnetizaciones
   close(14) ! Cerramos el archivo de energías
   print*, 'Simulación finalizada. Resultados guardados en "Datos/datos*.dat".'
end program Modelo
