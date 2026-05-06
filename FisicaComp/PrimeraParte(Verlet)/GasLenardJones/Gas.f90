program Gas
   implicit none
   real*8 t,paso,limite_tiempo, modulo_velocidad, num_aleatorio,pi
   real*8, allocatable :: posicion(:,:), velocidad(:,:), aceleracion(:,:), omega(:,:), r(:,:), energia_cinetica(:), energia_potencial(:), energia_total(:)
   integer :: i,j,k,NumeroParticulas, LongitudCaja
   character(len=100) :: linea,valor_j, nombre_archivo_total, nombre_energia_total

   call random_seed() ! Inicializamos la semilla de numeros aleatorios


   ! Inicializamos las variables
   t = 0.0d0 ! Tiempo inicial
   paso = 0.002d0 ! Paso de tiempo
   limite_tiempo = 15.0d0 ! Establecemos un límite de tiempo para la simulación
   pi = 4*datan(1.0d0) ! Calculamos el valor de pi


   NumeroParticulas = 100 ! Establecemos el número de partículas en el sistema
   LongitudCaja = 22 ! Establecemos la longitud de la caja


   modulo_velocidad = 1.0d0 ! Establecemos el módulo de la velocidad inicial de las partículas
   allocate(posicion(2,NumeroParticulas)) ! Reservamos memoria para las posiciones de las partículas
   allocate(velocidad(2,NumeroParticulas)) ! Reservamos memoria para las velocidades de las partículas
   allocate(aceleracion(2,NumeroParticulas)) ! Reservamos memoria para las aceleraciones de las partículas
   allocate(omega(2,NumeroParticulas)) ! Reservamos memoria para las velocidades angulares de las partículas
   allocate(r(NumeroParticulas,NumeroParticulas)) ! Reservamos memoria para las distancias entre partículas
   allocate(energia_cinetica(NumeroParticulas)) ! Reservamos memoria para las energías cinéticas de las partículas
   allocate(energia_potencial(NumeroParticulas)) ! Reservamos memoria para las energías potenciales de las partículas
   allocate(energia_total(NumeroParticulas)) ! Reservamos memoria para las energías totales de las partículas

   do i = 1, NumeroParticulas
      ! Velocidades iniciales aleatorias
      call random_number(num_aleatorio) ! Generamos un número aleatorio entre 0 y 1
      velocidad(1,i) = modulo_velocidad * cos(2.0d0*pi*num_aleatorio) ! Asignamos una velocidad inicial en x
      velocidad(2,i) = modulo_velocidad * sin(2.0d0*pi*num_aleatorio) ! Asignamos una velocidad inicial en y
      ! Posiciones iniciales aleatorias
      call random_number(num_aleatorio) ! Generamos un número aleatorio entre 0 y 1
      posicion(1,i) = LongitudCaja * num_aleatorio ! Asignamos una posición inicial en x
      call random_number(num_aleatorio) ! Generamos un número aleatorio entre 0 y 1
      posicion(2,i) = LongitudCaja * num_aleatorio ! Asignamos una posición inicial en y

   end do
   aceleracion(1,:) = 0.0d0 ! Inicializamos todas las aceleraciones en x
   aceleracion(2,:) = 0.0d0 ! Inicializamos todas las aceleraciones en y

   omega(1,:) = 0.0d0 ! Inicializamos todas las velocidades angulares en x
   omega(2,:) = 0.0d0 ! Inicializamos todas las velocidades angulares en y


   do i = 1, NumeroParticulas
      aceleracion(1,i) = 0.0d0 ! Inicializamos la aceleración en x de la partícula i
      aceleracion(2,i) = 0.0d0 ! Inicializamos la aceleración en y de la partícula i
      do j = 1, NumeroParticulas
         if (i /= j) then
            if (abs(posicion(1,i) - posicion(1,j)) > LongitudCaja/2.0d0) then
               if (posicion(1,i) > posicion(1,j)) then
                  posicion(1,j) = posicion(1,j) + LongitudCaja ! Aplicamos condiciones de frontera periódicas en x
               else
                  posicion(1,j) = posicion(1,j) - LongitudCaja
               end if
            end if
            if (abs(posicion(2,i) - posicion(2,j)) > LongitudCaja/2.0d0) then
               if (posicion(2,i) > posicion(2,j)) then
                  posicion(2,j) = posicion(2,j) + LongitudCaja ! Aplicamos condiciones de frontera periódicas en y
               else
                  posicion(2,j) = posicion(2,j) - LongitudCaja
               end if
            end if
            r(i,j) = sqrt((posicion(1,i) - posicion(1,j))**2 + (posicion(2,i) - posicion(2,j))**2) ! Calculamos la distancia entre las partículas i y j
         end if

      end do

      do j = 1, NumeroParticulas
         if (i /= j) then
            if (r(i,j)<3.d0) then
               aceleracion(1,i) = aceleracion(1,i) + 24.0d0 * ((2.0d0/r(i,j)**14) - (1.0d0/r(i,j)**8)) * (posicion(1,i) - posicion(1,j)) ! Calculamos la contribución a la aceleración en x de la partícula i debido a la partícula j
               aceleracion(2,i) = aceleracion(2,i) + 24.0d0 * ((2.0d0/r(i,j)**14) - (1.0d0/r(i,j)**8)) * (posicion(2,i) - posicion(2,j))
            end if

         end if
      end do


   end do



   do i = 1, NumeroParticulas
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') i
      nombre_archivo_total = 'Datos/datos_'//trim(adjustl(valor_j))//'.dat'
      nombre_energia_total = 'Datos/energia_'//trim(adjustl(valor_j))//'.dat'
      open(20+i, file = nombre_archivo_total, status= 'unknown')
      !open(200+i,file = nombre_energia_total, status= 'unknown')
   end do





   do while (t < limite_tiempo) ! Bucle principal de la simulación
      do i = 1, NumeroParticulas

         write(20+i,*) t, posicion(1,i), posicion(2,i)
         write (20+i,*)
         write (20+i,*)



         omega(1,i) = omega(1,i) + aceleracion(1,i) * paso ! Actualizamos la velocidad angular en x de la partícula i
         omega(2,i) = omega(2,i) + aceleracion(2,i) * paso ! Actualizamos la velocidad angular en y de la partícula i
         posicion(1,i) = posicion(1,i) + omega(1,i) * paso ! Actualizamos la posición en x de la partícula i
         posicion(2,i) = posicion(2,i) + omega(2,i) * paso ! Actualizamos la posición en y de la partícula i

      end do
      do i = 1, NumeroParticulas
         aceleracion(1,i) = 0.0d0 ! Inicializamos la aceleración en x de la partícula i
         aceleracion(2,i) = 0.0d0 ! Inicializamos la aceleración en y de la partícula i
         do j = 1, NumeroParticulas
            if (i /= j) then
               if (abs(posicion(1,i) - posicion(1,j)) > LongitudCaja/2.0d0) then
                  if (posicion(1,i) > posicion(1,j)) then
                     posicion(1,j) = posicion(1,j) + LongitudCaja ! Aplicamos condiciones de frontera periódicas en x
                  else
                     posicion(1,j) = posicion(1,j) - LongitudCaja
                  end if
               end if
               if (abs(posicion(2,i) - posicion(2,j)) > LongitudCaja/2.0d0) then
                  if (posicion(2,i) > posicion(2,j)) then
                     posicion(2,j) = posicion(2,j) + LongitudCaja ! Aplicamos condiciones de frontera periódicas en y
                  else
                     posicion(2,j) = posicion(2,j) - LongitudCaja
                  end if
               end if
               r(i,j) = sqrt((posicion(1,i) - posicion(1,j))**2 + (posicion(2,i) - posicion(2,j))**2) ! Calculamos la distancia entre las partículas i y j
            end if

         end do

         do j = 1, NumeroParticulas
            if (i /= j) then
               if (r(i,j)<3.d0) then
                  aceleracion(1,i) = aceleracion(1,i) + 24.0d0 * ((2.0d0/r(i,j)**14) - (1.0d0/r(i,j)**8)) * (posicion(1,i) - posicion(1,j)) ! Calculamos la contribución a la aceleración en x de la partícula i debido a la partícula j
                  aceleracion(2,i) = aceleracion(2,i) + 24.0d0 * ((2.0d0/r(i,j)**14) - (1.0d0/r(i,j)**8)) * (posicion(2,i) - posicion(2,j))
               end if
            end if

         end do


      end do

      do k = 1, NumeroParticulas
         velocidad(1,k) = omega(1,k) + (paso/2.0d0) * aceleracion(1,k) ! Actualizamos la velocidad en x de la partícula k
         velocidad(2,k) = omega(2,k) + (paso/2.0d0) * aceleracion(2,k) ! Actualizamos la velocidad en y de la partícula k
      end do
      t = t + paso ! Incrementamos el tiempo
   end do



   print *, 'Simulación completada'



   do i = 1, NumeroParticulas
      close(20+i) ! Cerramos los archivos de datos
      !close(200+i) ! Cerramos los archivos de energía
   end do

   deallocate(posicion) ! Liberamos la memoria de las posiciones
   deallocate(velocidad) ! Liberamos la memoria de las velocidades
   deallocate(aceleracion) ! Liberamos la memoria de las aceleraciones
   deallocate(omega) ! Liberamos la memoria de las velocidades angulares
   deallocate(r) ! Liberamos la memoria de las distancias
   deallocate(energia_cinetica) ! Liberamos la memoria de las energías cin
   deallocate(energia_potencial) ! Liberamos la memoria de las energías potenciales
   deallocate(energia_total) ! Liberamos la memoria de las energías totales


end program Gas

