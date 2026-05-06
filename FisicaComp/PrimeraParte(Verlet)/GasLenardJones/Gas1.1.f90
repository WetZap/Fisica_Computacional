program Gas
   implicit none
   real*8 t, paso, limite_tiempo, modulo_velocidad, num_aleatorio, pi
   real*8 dx, dy, r2, r_inv2, r_inv6, r_inv12, r_inv14_8, L_mitad, LongitudCaja
   real*8 energia_cinetica, energia_potencial, energia_total
   real*8, allocatable :: posicion(:,:), velocidad(:,:), aceleracion(:,:)
   integer :: i, j, NumeroParticulas, contador_pasos
   logical :: solapamiento

   call random_seed() ! Inicializamos la semilla de números aleatorios

   t = 0.0d0 ! Tiempo inicial
   paso = 0.002d0 ! Paso temporal propuesto
   limite_tiempo = 15.0d0 ! Límite de tiempo
   pi = 4.0d0 * datan(1.0d0)

   NumeroParticulas = 100
   LongitudCaja = 22.0d0
   L_mitad = LongitudCaja / 2.0d0
   modulo_velocidad = 1.0d0
   contador_pasos = 0 ! Inicializamos el contador de pasos

   allocate(posicion(2, NumeroParticulas))
   allocate(velocidad(2, NumeroParticulas))
   allocate(aceleracion(2, NumeroParticulas))

   ! ==========================================
   ! 1. Inicialización del estado (Sin solapamiento)
   ! ==========================================
   do i = 1, NumeroParticulas
      call random_number(num_aleatorio)
      velocidad(1,i) = modulo_velocidad * cos(2.0d0*pi*num_aleatorio)
      velocidad(2,i) = modulo_velocidad * sin(2.0d0*pi*num_aleatorio)

      solapamiento = .true.
      do while (solapamiento)
         call random_number(num_aleatorio)
         posicion(1,i) = LongitudCaja * num_aleatorio
         call random_number(num_aleatorio)
         posicion(2,i) = LongitudCaja * num_aleatorio

         solapamiento = .false.
         ! Comprobar distancia con las partículas ya creadas
         do j = 1, i - 1
            dx = posicion(1,i) - posicion(1,j)
            dy = posicion(2,i) - posicion(2,j)

            if (dx > L_mitad) dx = dx - LongitudCaja
            if (dx < -L_mitad) dx = dx + LongitudCaja
            if (dy > L_mitad) dy = dy - LongitudCaja
            if (dy < -L_mitad) dy = dy + LongitudCaja

            ! Si están a menos de 1.0 sigma, generamos nuevas coordenadas
            if (dx**2 + dy**2 < 1.0d0) then
               solapamiento = .true.
               exit
            end if
         end do
      end do
   end do

   ! ==========================================
   ! 2. Cálculo inicial de aceleraciones y energía potencial
   ! ==========================================
   aceleracion = 0.0d0
   energia_potencial = 0.0d0

   do i = 1, NumeroParticulas - 1
      do j = i + 1, NumeroParticulas
         dx = posicion(1,i) - posicion(1,j)
         dy = posicion(2,i) - posicion(2,j)

         if (dx > L_mitad) dx = dx - LongitudCaja
         if (dx < -L_mitad) dx = dx + LongitudCaja
         if (dy > L_mitad) dy = dy - LongitudCaja
         if (dy < -L_mitad) dy = dy + LongitudCaja

         r2 = dx**2 + dy**2
         if (r2 < 9.0d0) then ! corte en r < 3 => r^2 < 9
            r_inv2 = 1.0d0 / r2
            r_inv6 = r_inv2**3
            r_inv12 = r_inv6**2

            ! Sumamos al potencial total: V = 4 * (1/r^12 - 1/r^6)
            energia_potencial = energia_potencial + 4.0d0 * (r_inv12 - r_inv6)

            r_inv14_8 = 24.0d0 * (2.0d0 * r_inv12 - r_inv6) * r_inv2
            aceleracion(1,i) = aceleracion(1,i) + r_inv14_8 * dx
            aceleracion(2,i) = aceleracion(2,i) + r_inv14_8 * dy
            aceleracion(1,j) = aceleracion(1,j) - r_inv14_8 * dx
            aceleracion(2,j) = aceleracion(2,j) - r_inv14_8 * dy
         end if
      end do
   end do

   ! Abrimos los archivos de posiciones y energías
   open(21, file='Datos/datos_T1.dat', status='replace')
   open(22, file='Datos/energia_T1.dat', status='replace')

   ! ==========================================
   ! Bucle principal de la simulación (Verlet)
   ! ==========================================
   do while (t < limite_tiempo)

      ! Guardar posiciones y calcular energías SÓLO cada 25 pasos
      if (mod(contador_pasos, 5) == 0) then
         energia_cinetica = 0.0d0

         do i = 1, NumeroParticulas
            ! Cálculo de la energía cinética total K = 0.5 * m * v^2 (m=1)
            energia_cinetica = energia_cinetica + 0.5d0 * (velocidad(1,i)**2 + velocidad(2,i)**2)
            write(21, '(3F15.6)') t, posicion(1,i), posicion(2,i)
         end do
         write(21, *)
         write(21, *)

         energia_total = energia_cinetica + energia_potencial
         write(22, '(4F15.6)') t, energia_cinetica, energia_potencial, energia_total
      end if

      do i = 1, NumeroParticulas
         ! Paso 1 de Velocity Verlet: r(t+dt) y v(t+dt/2)
         posicion(1,i) = posicion(1,i) + velocidad(1,i)*paso + 0.5d0*aceleracion(1,i)*paso**2
         posicion(2,i) = posicion(2,i) + velocidad(2,i)*paso + 0.5d0*aceleracion(2,i)*paso**2

         velocidad(1,i) = velocidad(1,i) + 0.5d0*aceleracion(1,i)*paso
         velocidad(2,i) = velocidad(2,i) + 0.5d0*aceleracion(2,i)*paso

         ! Fronteras periódicas robustas (do while en vez de if)
         do while (posicion(1,i) >= LongitudCaja)
            posicion(1,i) = posicion(1,i) - LongitudCaja
         end do
         do while (posicion(1,i) < 0.0d0)
            posicion(1,i) = posicion(1,i) + LongitudCaja
         end do
         do while (posicion(2,i) >= LongitudCaja)
            posicion(2,i) = posicion(2,i) - LongitudCaja
         end do
         do while (posicion(2,i) < 0.0d0)
            posicion(2,i) = posicion(2,i) + LongitudCaja
         end do
      end do

      ! Calcular nuevas aceleraciones y NUEVA energía potencial a(t+dt)
      aceleracion = 0.0d0
      energia_potencial = 0.0d0

      do i = 1, NumeroParticulas - 1
         do j = i + 1, NumeroParticulas
            dx = posicion(1,i) - posicion(1,j)
            dy = posicion(2,i) - posicion(2,j)

            if (dx > L_mitad) dx = dx - LongitudCaja
            if (dx < -L_mitad) dx = dx + LongitudCaja
            if (dy > L_mitad) dy = dy - LongitudCaja
            if (dy < -L_mitad) dy = dy + LongitudCaja

            r2 = dx**2 + dy**2
            if (r2 < 9.0d0) then
               r_inv2 = 1.0d0 / r2
               r_inv6 = r_inv2**3
               r_inv12 = r_inv6**2

               energia_potencial = energia_potencial + 4.0d0 * (r_inv12 - r_inv6)

               r_inv14_8 = 24.0d0 * (2.0d0 * r_inv12 - r_inv6) * r_inv2
               aceleracion(1,i) = aceleracion(1,i) + r_inv14_8 * dx
               aceleracion(2,i) = aceleracion(2,i) + r_inv14_8 * dy
               aceleracion(1,j) = aceleracion(1,j) - r_inv14_8 * dx
               aceleracion(2,j) = aceleracion(2,j) - r_inv14_8 * dy
            end if
         end do
      end do

      ! Paso 2 de Velocity Verlet: v(t+dt) completo
      do i = 1, NumeroParticulas
         velocidad(1,i) = velocidad(1,i) + 0.5d0 * aceleracion(1,i) * paso
         velocidad(2,i) = velocidad(2,i) + 0.5d0 * aceleracion(2,i) * paso
      end do

      t = t + paso
      contador_pasos = contador_pasos + 1
   end do

   print *, 'Simulación completada'

   ! Cierre correcto de los archivos usados
   close(21)
   close(22)

   deallocate(posicion)
   deallocate(velocidad)
   deallocate(aceleracion)

end program Gas
