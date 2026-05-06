module hermite_poly
   implicit none
contains

   ! Función para calcular Hn(x) utilizando la relación de recurrencia
   real*8 function hermite(n, x)
      integer, intent(in) :: n
      real*8, intent(in) :: x
      real*8 :: h_prev, h_curr, h_next
      integer :: i

      if (n < 0) then
         hermite = 0.0
         return
      else if (n == 0) then
         hermite = 1.0
         return
      else if (n == 1) then
         hermite = 2.0 * x
         return
      end if

      ! Inicialización
      h_prev = 1.0  ! H0
      h_curr = 2.0 * x ! H1

      ! Bucle para generar Hn(x) a partir de la recurrencia
      do i = 1, n - 1
         h_next = 2.0 * x * h_curr - 2.0 * i * h_prev
         h_prev = h_curr
         h_curr = h_next
      end do

      hermite = h_curr
   end function hermite

end module hermite_poly

program Resolucion
   use hermite_poly
   implicit none
   real*8 delta_x, delta_y, delta_z, delta_V, delta_t, Longitud, omega, pi
   real*8 valor_promedio_x, valor_promedio_p, norma, norma_inicial, hamiltoniano
   real*8 incert_x, incert_p, valor_promedio_x_2, omega_2, valor_alpha
   real*8 valor_promedio_y, valor_promedio_z

   real*8, dimension(:), allocatable :: V, x_discreto, y_discreto, z_discreto, tiempo_discreto
   complex*16, dimension(:), allocatable :: alpha, gammia, beta, q
   complex*16, dimension(:,:,:), allocatable :: phi

   complex*16 :: dphi_dx, dphi_dx_2, dphi_dy_2, dphi_dz_2
   integer i, j, k, n_t, N, S, corte

   ! Inicializacion de variables
   S = 100
   Longitud = 1.d0
   delta_x = Longitud / real(S, 8)
   delta_y = Longitud / real(S, 8)
   delta_z = Longitud / real(S, 8)
   delta_V = delta_x * delta_y * delta_z
   delta_t = 0.000001d0
   N = 3000
   pi = 4.d0 * datan(1.d0)
   norma = 0.d0
   corte = 5 ! Escribe 1 frame cada 5 iteraciones

   omega = delta_t / (delta_x**2)
   omega_2 = 200.d0

   allocate(V(0:S), q(0:S), x_discreto(0:S), y_discreto(0:S), z_discreto(0:S))
   allocate(alpha(0:S-1), beta(0:S-1), gammia(0:S-1), tiempo_discreto(0:N-1))
   allocate(phi(0:S,0:S,0:S))

   ! Inicializacion de arrays
   x_discreto = [(i * delta_x, i=0, S)]
   y_discreto = [(i * delta_y, i=0, S)]
   z_discreto = [(i * delta_z, i=0, S)]
   tiempo_discreto = [(i * delta_t, i=0, N-1)]

   q(0) = (0.d0, 0.d0)
   q(S) = (0.d0, 0.d0)

   ! Potencial 1D armónico
   do i = 0, S
      ! V(i) = omega_2**2 / 4.d0 * (x_discreto(i) - 0.5)**2
      V(i) = 0.d0 ! Potencial nulo para probar evolución libre
   end do

   ! Inicialización vectores Tridiagonales
   gammia(S-1) = 1.d0/(-2.d0 + (2.d0*(0.d0,1.d0)/omega - V(S-1)))
   alpha(S-1) = (0.d0, 0.d0)

   do i = S-2, 0, -1
      alpha(i) = - gammia(i+1)
      gammia(i) = 1.d0/(-2.d0 + (2.d0*(0.d0,1.d0)/omega - V(i)+ alpha(i)))
   end do

   ! --- Funcion de onda inicial 3D ---
   valor_alpha = sqrt(omega_2/2.d0)
   norma_inicial = 0.d0
   phi = (0.d0, 0.d0)

   do k = 1, S-1
      do j = 1, S-1
         do i = 1, S-1
            !phi(i,j,k) = (hermite(3, valor_alpha*(x_discreto(i)-0.5)) * exp(-(valor_alpha**2 *(x_discreto(i)-0.5)**2)/2.d0)) * &
            !(hermite(3, valor_alpha*(y_discreto(j)-0.5)) * exp(-(valor_alpha**2 *(y_discreto(j)-0.5)**2)/2.d0)) * &
            !(hermite(3, valor_alpha*(z_discreto(k)-0.5)) * exp(-(valor_alpha**2 *(z_discreto(k)-0.5)**2)/2.d0))
            phi(i,j,k) = exp((0.d0,1.d0)*i*delta_x*(1.d0/(2.d0*sqrt(delta_t))))*exp((-8.d0*(4.d0*i - real(S,8))**2)/(real(S,8)**2)) * &
               exp((0.d0,1.d0)*j*delta_y*(1.d0/(2.d0*sqrt(delta_t))))*exp((-8.d0*(4.d0*j - real(S,8))**2)/(real(S,8)**2)) * &
               exp((0.d0,1.d0)*k*delta_z*(1.d0/(2.d0*sqrt(delta_t))))*exp((-8.d0*(4.d0*k - real(S,8))**2)/(real(S,8)**2))
            norma_inicial = norma_inicial + (abs(phi(i,j,k))**2) * delta_V
         end do
      end do
   end do

   ! Normalizamos la funcion de onda 3D
   do k = 1, S-1
      do j = 1, S-1
         do i = 1, S-1
            phi(i,j,k) = phi(i,j,k) / sqrt(norma_inicial)
         end do
      end do
   end do

   ! Abrimos archivos de datos
   open(12, file="Data/Auto/Phi_Prob_2D_Slice.dat", status="replace")
   !open(13, file="Data/Auto/ValorMediox.dat", status="replace")
   !open(14, file="Data/Auto/ValorMediop.dat", status="replace")
   ! open(15, file="Data/Auto/Norma.dat", status="replace")
   ! open(17, file="Data/Auto/Hamiltoniano.dat", status="replace")
   !open(18, file="Data/Auto/PrincIncertidumbre.dat", status="replace")

   ! ================================================
   ! BUCLE TEMPORAL
   ! ================================================
   do n_t = 0, N-1

      ! Escritura y Observables cada 'corte' iteraciones
      if (mod(n_t, corte) == 0) then
         ! valor_promedio_x = 0.d0
         ! valor_promedio_x_2 = 0.d0
         ! valor_promedio_p = 0.d0
         ! hamiltoniano = 0.d0
         ! norma = 0.d0

         ! do k = 1, S-1
         !    do j = 1, S-1
         !       do i = 1, S-1
         !          norma = norma + (abs(phi(i,j,k))**2) * delta_V
         !          valor_promedio_x = valor_promedio_x + x_discreto(i) * (abs(phi(i,j,k))**2) * delta_V
         !          valor_promedio_x_2 = valor_promedio_x_2 + (x_discreto(i)**2) * (abs(phi(i,j,k))**2) * delta_V

         !         dphi_dx = (phi(i+1,j,k) - phi(i-1,j,k)) / (2.d0 * delta_x)
         !           dphi_dx_2 = (phi(i+1,j,k) + phi(i-1,j,k) - 2.d0*phi(i,j,k)) / (delta_x**2)
         !          dphi_dy_2 = (phi(i,j+1,k) + phi(i,j-1,k) - 2.d0*phi(i,j,k)) / (delta_y**2)
         !         dphi_dz_2 = (phi(i,j,k+1) + phi(i,j,k-1) - 2.d0*phi(i,j,k)) / (delta_z**2)
!
         !                 valor_promedio_p = valor_promedio_p + real(conjg(phi(i,j,k)) * (-1.d0,0.d0) * (0.d0,1.d0) * dphi_dx, 8) * delta_V
         !                hamiltoniano = hamiltoniano + real(conjg(phi(i,j,k)) * (-1.d0,0.d0) * (dphi_dx_2 + dphi_dy_2 + dphi_dz_2), 8) * delta_V
         !            end do
         !        end do
         !    end do

         !   incert_x = sqrt(abs(valor_promedio_x_2 - valor_promedio_x**2))
         !  incert_p = sqrt(abs(hamiltoniano - valor_promedio_p**2))

         ! write(13,'(2ES15.6)') tiempo_discreto(n_t), valor_promedio_x
         !write(14,'(2ES15.6)') tiempo_discreto(n_t), valor_promedio_p
         !write(15,'(2ES15.6)') tiempo_discreto(n_t), norma
         !write(17,'(2ES15.6)') tiempo_discreto(n_t), hamiltoniano
         !write(18,'(2ES15.6)') tiempo_discreto(n_t), incert_x * incert_p

         ! ESCRITURA PARA GNUPLOT (CORTE Z EN EL MEDIO DE LA CAJA)
         k = S/2
         do j = 1, S-1
            do i = 1, S-1
               write(12,'(3ES15.6)') x_discreto(i), y_discreto(j), abs(phi(i,j,k))**2

            end do
            write(12,*) ! Línea en blanco para separar barridos en Y
         end do
         write(12,*) ; write(12,*) ! Doble salto de línea para separar bloques (frames)
      end if

      ! ================================================
      ! SPLIT-OPERATOR: Evolución en dirección X
      ! ================================================
      do k = 1, S-1
         do j = 1, S-1
            beta(S-1) = (0.d0, 0.d0)
            do i = S-2, 0, -1
               beta(i) = gammia(i+1) * ((4.d0*(0.d0,1.d0)*phi(i+1, j, k))/omega - beta(i+1))
            end do
            do i = 1, S-1
               q(i) = alpha(i-1)*q(i-1) + beta(i-1)
            end do
            do i = 1, S-1
               phi(i, j, k) = q(i) - phi(i, j, k)
            end do
         end do
      end do

      ! ================================================
      ! SPLIT-OPERATOR: Evolución en dirección Y
      ! ================================================
      do k = 1, S-1
         do i = 1, S-1
            beta(S-1) = (0.d0, 0.d0)
            do j = S-2, 0, -1
               beta(j) = gammia(j+1) * ((4.d0*(0.d0,1.d0)*phi(i, j+1, k))/omega - beta(j+1))
            end do
            do j = 1, S-1
               q(j) = alpha(j-1)*q(j-1) + beta(j-1)
            end do
            do j = 1, S-1
               phi(i, j, k) = q(j) - phi(i, j, k)
            end do
         end do
      end do

      ! ================================================
      ! SPLIT-OPERATOR: Evolución en dirección Z
      ! ================================================
      do j = 1, S-1
         do i = 1, S-1
            beta(S-1) = (0.d0, 0.d0)
            do k = S-2, 0, -1
               beta(k) = gammia(k+1) * ((4.d0*(0.d0,1.d0)*phi(i, j, k+1))/omega - beta(k+1))
            end do
            do k = 1, S-1
               q(k) = alpha(k-1)*q(k-1) + beta(k-1)
            end do
            do k = 1, S-1
               phi(i, j, k) = q(k) - phi(i, j, k)
            end do
         end do
      end do

   end do

   close(12) ; close(13) ; close(14) ; close(15); close(17); close(18)
   deallocate(V, alpha, beta, q, phi, gammia)
   deallocate(x_discreto, y_discreto, z_discreto, tiempo_discreto)

end program Resolucion
