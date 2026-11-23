program Modelo
   implicit none
   integer N,k,l,i,m,j, pos1,pos2,estado1, estado2, estado4, estado5,estado3, cont, iteraciones
   integer, allocatable :: configuracion(:,:), patron1(:,:)
   real *8, allocatable :: omega(:,:)
   real *8 r, T, p, tiempo, limite_tiempo,paso, energia, delta_H, delta_s, M_val, peso_a
   character(len=50) :: nombre_archivo_total, nombre_archivo_energia, valor_j
   character(len=1080) :: linea ! Aumentamos el tamaño a 1080 para que quepan los N=1080 caracteres de golpe

   N = 150 !Valor de la cantidad de celdas que habrá será una config. cuadrada
   limite_tiempo = 2500000000.0d0! Establecemos un límite de tiempo para la simulación
   tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
   paso = 1.0d0 ! Establecemos el paso de tiempo para la simulación
   cont = 0 ! Inicializamos el contador de iteracione
   iteraciones = 10
   allocate(configuracion(N,N)) ! Reservamos memoria para la configuración del sistema
   allocate(patron1(N,N)) ! Reservamos memoria para el patrón que queremos almacenar en el sistema
   allocate(omega(N,N)) ! Reservamos memoria para la matriz de pesos del sistema
   call random_seed() ! Inicializamos la semilla de numeros aleatorios

   !----------------------------------------------------------------------------------------------
   !Leemos el patrón que queremos almacenar en el sistema desde un archivo de texto
   !----------------------------------------------------------------------------------------------
   open(10, file='../Patrones/Patron2.dat', status='old')
   open(11, file='../Data/Datos/Temperaturas.dat', status='unknown',form='formatted') ! Abrimos un archivo para guardar las temperaturas
   do i = 1, N
      read(10, '(A)') linea           ! Leemos la fila completa como texto
      do j = 1, N
         read(linea(j:j), '(I1)') patron1(i,j) ! Leemos cada carácter individualmente y lo convertimos a entero
         ! Extraemos cada 0 o 1 individualmente
      end do
   end do
   close(10)

   !----------------------------------------------------------------------------------------------
   ! Generamos la configuración inicial del sistema.
   !----------------------------------------------------------------------------------------------
   write (11,*) N
   T = 0.00001d0
   peso_a = 0.d0 ! Inicializamos el peso a para la matriz de pesos del sistema

   do i= 1,N
      do j = 1, N
         peso_a = peso_a + patron1(i,j) ! Calculamos el peso a para la matriz de pesos del sistema
      end do
   end do

   peso_a = peso_a/(N*N) ! Calculamos el peso a para la matriz de pesos del sistema

   do l = 1, iteraciones
      write(valor_j, '(I10)') l
      nombre_archivo_total = '../Data/Datos/datos_'//trim(adjustl(valor_j))//'.dat'

      T = T *2.5d0
      tiempo = 0.0d0 ! Inicializamos el tiempo de la simulación
      cont = -1 ! Inicializamos el contador de iteraciones
      delta_H = 0.d0 ! Inicializamos el cambio de energía para medir la probabilidad de aceptar un cambio de estado en el sistema
      delta_s = 0.d0 ! Inicializamos el cambio de estado para medir la probabilidad de aceptar un cambio de estado en el sistema
      M_val = 0.d0 ! Inicializamos el valor de M para medir la similitud entre la configuración del sistema y el patrón que queremos almacenar




      open(20+l, file=nombre_archivo_total,status='unknown',form='unformatted',access='stream') ! Abrimos un archivo para guardar los resultados
      write(11,*) T ! Guardamos la temperatura en el archivo de resultados


      m = 2 !Valor de m para generar números enteros aleatorios entre 1 y
      do i = 1, N
         do j = 1, N
            call random_number(r)
            k = int(m*r) + 1
            if (k == 1) then
               configuracion(i,j) = 0 ! Asignamos el valor -1 a la celda si el número aleatorio es 1
            else
               configuracion(i,j) = 1 ! Asignamos el valor 1 a la celda si el número aleatorio es 2
            end if
         end do
      end do



      M_val = 0.0d0 ! Inicializamos el valor de M para medir la similitud entre la configuración del sistema y el patrón que queremos almacenar
      do i = 1, N
         do j = 1, N
            M_val = M_val + (patron1(i,j) - peso_a)*(configuracion(i,j))
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
         delta_s =1.0d0 -2.d0 * estado1
         delta_H =- (1.0d0 / (N*N)) * (patron1(pos1,pos2) - peso_a) * M_val * delta_s - (0.5d0 / (N*N)) * (patron1(pos1,pos2) - peso_a)**2

         p = min(1.0d0, exp(-delta_H/T)) ! Calculamos la probabilidad de aceptar el cambio de estado de la celda seleccionada

         !----------------------------------------------------------------------------------------------
         ! Decidimos si aceptamos el cambio de estado de la celda seleccionada o no, comparando la probabilidad calculada con un número aleatorio.
         !----------------------------------------------------------------------------------------------
         call random_number(r)
         if (r < p) then
            configuracion(pos1,pos2) = 1- estado1 ! Cambiamos el estado de la celda seleccionada
            M_val = M_val + (patron1(pos1,pos2) - peso_a) * delta_s
         end if

         cont = cont + 1 ! Incrementamos el contador de iteraciones

         if (cont == N*N.or. cont == 0) then
            write(20+l) configuracion
            cont = 0
         end if


         tiempo = tiempo+paso

      end do

      close(20+l) ! Cerramos el archivo de resultados
   end do
   close(11) ! Cerramos el archivo de temperaturas
   deallocate(configuracion) ! Liberamos la memoria reservada para la configuración del sistema
   deallocate(patron1)
   deallocate(omega)

   print*, 'Simulación finalizada. Resultados guardados en "Datos/datos*.dat".'
end program Modelo
