program Modelo
   implicit none
   integer N,k,i,m,j, pos1,pos2,estado1, cont, iteraciones,num_medidas
   integer, allocatable :: configuracion(:,:)
   real *8 r, T, p, tiempo, limite_tiempo,paso, energia, energia_promedio, energia_acumulada, energia_media_total, energia_instantanea, magnetizacion_instantanea, magnetizacion_acumulada, magnetizacion_media_total
   character(len=50) :: nombre_archivo_total, nombre_archivo_energia, valor_j,linea


   N = 50 !Valor de la cantidad de celdas que habrá será una config. cuadrada
   limite_tiempo = 2500000.0d0! Establecemos un límite de tiempo para la simulación
   tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
   paso = 1.0d0 ! Establecemos el paso de tiempo para la simulación
   cont = 0 ! Inicializamos el contador de iteraciones

   allocate(configuracion(N,N)) ! Reservamos memoria para la configuración del sistema
   call random_seed() ! Inicializamos la semilla de numeros aleatorios

   open(12, file="Data/DatosSin/EnergiaSin.dat",status='unknown') ! Abrimos un archivo para guardar los resultados
   open(13, file="Data/DatosSin/MagnetizacionSin.dat",status='unknown') ! Abrimos un archivo para guardar los resultados
   open(14, file="Data/DatosSin/Temperaturas.dat",status='unknown') ! Abrimos un archivo para guardar los resultados
   !----------------------------------------------------------------------------------------------
   ! Generamos la configuración inicial del sistema.
   !----------------------------------------------------------------------------------------------
   do iteraciones = 1, 15

      call random_number(r) ! Generamos un número aleatorio entre 0 y 1
      T = 5.0d0 * r ! Asignamos un valor aleatorio
      tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
      cont = 0 ! Inicializamos el contador de iteraciones
      energia_promedio = 0.0d0 ! Inicializamos la energía promedio del sistema
      energia_acumulada = 0.0d0 ! Inicializamos la energía acumulada del sistema
      magnetizacion_acumulada = 0.0d0 ! Inicializamos la magnetización acumulada del sistema
      magnetizacion_instantanea = 0.0d0 ! Inicializamos la magnetización instantánea del sistema
      num_medidas = 0 ! Inicializamos el número de medidas



      write(valor_j, '(I10)') iteraciones

      ! Definimos los nombres de los archivos que guardaremos
      nombre_archivo_total = 'Data/DatosSin/datos'//trim(adjustl(valor_j))//'.dat'



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
         energia = 2.d0 * estado1  ! Calculamos la energía del sistema antes de cambiar el estado de la celda seleccionada



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

         if (mod(cont, 100*N*N) == 0) then

            energia_instantanea = 0.0d0
            magnetizacion_instantanea = 0.0d0
            do i = 1, N
               do j = 1, N
                  energia_instantanea = energia_instantanea - configuracion(i,j)
                  magnetizacion_instantanea = magnetizacion_instantanea + configuracion(i,j)
               end do
            end do
            energia_acumulada = energia_acumulada + energia_instantanea
            magnetizacion_acumulada = magnetizacion_acumulada + magnetizacion_instantanea
            num_medidas = num_medidas + 1
         end if

         tiempo = tiempo+paso

      end do

      close(11) ! Cerramos el archivo de resultados

      energia_media_total = energia_acumulada / num_medidas
      magnetizacion_media_total = magnetizacion_acumulada / num_medidas



      write(12,*) T , energia_media_total / (N * N) ! Guardamos la temperatura utilizada en cada simulación
      write(12,*)
      write(12,*)
      write(13,*) T, magnetizacion_media_total / (N * N) ! Guardamos la magnetización del sistema
      write(13,*)
      write(13,*)
      write(14,*) T ! Guardamos la temperatura utilizada en cada simulación
   end do
   deallocate(configuracion) ! Liberamos la memoria reservada para la configuración del sistema

   close(12) ! Cerramos el archivo de temperaturas
   close(13) ! Cerramos el archivo de magnetización
   print*, 'Simulación finalizada. Resultados guardados en "DatosSin/datos*.dat".'
end program Modelo
