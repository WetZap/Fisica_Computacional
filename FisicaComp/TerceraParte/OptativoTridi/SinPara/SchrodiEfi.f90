module hermite_poly
   implicit none
contains

   ! H_n(x) via recurrencia — sin ramas innecesarias
   pure real(8) function hermite(n, x)
      integer, intent(in) :: n
      real(8), intent(in) :: x
      real(8) :: h_prev, h_curr, h_next
      integer :: i

      select case (n)
       case (:-1); hermite = 0.0d0; return
       case (0);   hermite = 1.0d0; return
       case (1);   hermite = 2.0d0 * x; return
      end select

      h_prev = 1.0d0
      h_curr = 2.0d0 * x
      do i = 1, n - 1
         h_next = 2.0d0 * x * h_curr - 2.0d0 * i * h_prev
         h_prev = h_curr
         h_curr = h_next
      end do
      hermite = h_curr
   end function hermite

end module hermite_poly


program Resolucion
   use hermite_poly
   implicit none

   integer,  parameter :: dp = kind(1.0d0)
   integer,  parameter :: S = 100, N = 100000, corte = 10

   real(dp), parameter :: Longitud = 1.0_dp
   real(dp), parameter :: delta_t  = 1.0e-5_dp
   real(dp), parameter :: sigma_0  = 0.1_dp
   real(dp), parameter :: x_0      = 0.5_dp
   real(dp), parameter :: p_0      = 20.0_dp
   real(dp), parameter :: omega_2  = 200.0_dp
   real(dp), parameter :: pi       = 4.0_dp * atan(1.0_dp)

   ! Pasos espaciales como parámetros derivados
   real(dp), parameter :: delta_x  = Longitud / real(S, dp)
   real(dp), parameter :: delta_y  = delta_x
   real(dp), parameter :: delta_z  = delta_x
   real(dp), parameter :: delta_V  = delta_x * delta_y * delta_z
   real(dp), parameter :: omega    = delta_t / (delta_x**2)

   ! Constantes complejas precalculadas (evita reconstrucción en bucles)
   complex(dp), parameter :: ci      = (0.0_dp, 1.0_dp)
   complex(dp), parameter :: four_ci = (0.0_dp, 4.0_dp)

   real(dp), allocatable :: V(:), x_disc(:), y_disc(:), z_disc(:)
   complex(dp), allocatable :: alpha(:), gammia(:)
   complex(dp), allocatable :: phi(:,:,:)

   real(dp)    :: norma_inicial, inv_sqrt_norma
   real(dp)    :: xi, yj, zk, dx2, val
   complex(dp) :: phi_ijk, fci_over_omega
   integer     :: i, j, k, n_t

   ! Precalcular escalar complejo usado en el sweep
   fci_over_omega = four_ci / omega

   allocate(V(0:S), x_disc(0:S), y_disc(0:S), z_disc(0:S))
   allocate(alpha(0:S-1), gammia(0:S-1))
   allocate(phi(0:S, 0:S, 0:S))

   ! Arrays de coordenadas
   do i = 0, S
      x_disc(i) = i * delta_x
      y_disc(i) = i * delta_y
      z_disc(i) = i * delta_z
   end do


   ! Potencial nulo
   V = 0.0_dp

   ! --- Vectores tridiagonales (precalcular 2i/omega - V una vez) ---
   block
      complex(dp) :: diag_base
      diag_base = 2.0_dp * ci / omega  ! parte común del denominador
      gammia(S-1) = 1.0_dp / (-2.0_dp + diag_base - V(S-1))
      alpha(S-1)  = (0.0_dp, 0.0_dp)
      do i = S-2, 0, -1
         alpha(i)  = -gammia(i+1)
         gammia(i) =  1.0_dp / (-2.0_dp + diag_base - V(i) + alpha(i))
      end do
   end block

   ! --- Función de onda inicial gaussiana 3D ---
   phi = (0.0_dp, 0.0_dp)
   norma_inicial = 0.0_dp

   ! Precalcular -1/(2*sigma^2)
   dx2 = -1.0_dp / (2.0_dp * sigma_0**2)

   !$OMP PARALLEL DO PRIVATE(i,j,k,xi,yj,zk,phi_ijk) REDUCTION(+:norma_inicial) COLLAPSE(3)
   do k = 1, S-1
      do j = 1, S-1
         do i = 1, S-1
            xi  = x_disc(i) - x_0
            yj  = y_disc(j) - x_0
            zk  = z_disc(k) - x_0
            phi_ijk = exp(ci * p_0 * x_disc(i)) * &
               exp(dx2 * (xi*xi + yj*yj + zk*zk))
            phi(i,j,k)    = phi_ijk
            norma_inicial = norma_inicial + real(phi_ijk * conjg(phi_ijk), dp) * delta_V
         end do
      end do
   end do
   !$OMP END PARALLEL DO

   ! Normalizar con un solo bucle y división precalculada
   inv_sqrt_norma = 1.0_dp / sqrt(norma_inicial)
   !$OMP PARALLEL WORKSHARE
   phi(1:S-1, 1:S-1, 1:S-1) = phi(1:S-1, 1:S-1, 1:S-1) * inv_sqrt_norma
   !$OMP END PARALLEL WORKSHARE

   open(12, file="Data/Auto/Phi_Prob_2D_Slice.bin", access="stream",form="unformatted", status="replace")  ! I/O con buffer grande

   ! ================================================
   ! BUCLE TEMPORAL
   ! ================================================
   do n_t = 0, N-1

      ! --- Escritura del slice Z cada 'corte' pasos ---
      if (mod(n_t, corte) == 0) then
         block
            ! Creamos un array temporal 2D para volcarlo de golpe a disco
            real(dp) :: slice_2d(1:S-1, 1:S-1)

            k = S*0.2d0
            do j = 1, S-1
               do i = 1, S-1
                  ! Solo guardamos la probabilidad |phi|^2
                  slice_2d(i,j) = real(phi(i,j,k)*conjg(phi(i,j,k)), dp)
               end do
            end do

            ! Al escribir el array completo de golpe en modo stream,
            ! se hace a la máxima velocidad del disco.
            write(12) slice_2d
         end block
      end if
      ! ================================================
      ! SPLIT-OPERATOR X — acceso contiguo (stride-1 en i)
      ! ================================================
      !$OMP PARALLEL DO PRIVATE(i,j,k) COLLAPSE(2)
      do k = 1, S-1
         do j = 1, S-1
            block
               complex(dp) :: beta(0:S-1), q(0:S)
               beta(S-1) = (0.0_dp, 0.0_dp)
               do i = S-2, 0, -1
                  beta(i) = gammia(i+1) * (fci_over_omega * phi(i+1,j,k) - beta(i+1))
               end do
               q(0) = (0.0_dp, 0.0_dp)
               q(S) = (0.0_dp, 0.0_dp)

               do i = 1, S-1
                  q(i) = alpha(i-1)*q(i-1) + beta(i-1)
               end do
               do i = 1, S-1
                  phi(i,j,k) = q(i) - phi(i,j,k)
               end do
            end block
         end do
      end do
      !$OMP END PARALLEL DO
      ! ================================================
      ! SPLIT-OPERATOR Y — REORDENADO PARA CACHE PERFECTO
      ! ================================================
      !$OMP PARALLEL DO PRIVATE(i,j,k)
      do k = 1, S-1
         block
            ! Matrices temporales para resolver 99 líneas simultáneamente
            complex(dp) :: beta_y(1:S-1, 0:S-1), q_y(1:S-1, 0:S-1)

            do i = 1, S-1
               beta_y(i, S-1) = (0.0_dp, 0.0_dp)
               q_y(i, 0)      = (0.0_dp, 0.0_dp)
            end do

            do j = S-2, 0, -1
               !$OMP SIMD
               do i = 1, S-1
                  beta_y(i, j) = gammia(j+1) * (fci_over_omega * phi(i,j+1,k) - beta_y(i, j+1))
               end do
            end do

            do j = 1, S-1
               !$OMP SIMD
               do i = 1, S-1
                  q_y(i, j) = alpha(j-1)*q_y(i, j-1) + beta_y(i, j-1)
               end do
            end do

            do j = 1, S-1
               !$OMP SIMD
               do i = 1, S-1
                  phi(i, j, k) = q_y(i, j) - phi(i, j, k)
               end do
            end do
         end block
      end do
      !$OMP END PARALLEL DO

      ! ================================================
      ! SPLIT-OPERATOR Z — REORDENADO PARA CACHE PERFECTO
      ! ================================================
      !$OMP PARALLEL DO PRIVATE(i,j,k)
      do j = 1, S-1
         block
            complex(dp) :: beta_z(1:S-1, 0:S-1), q_z(1:S-1, 0:S-1)

            do i = 1, S-1
               beta_z(i, S-1) = (0.0_dp, 0.0_dp)
               q_z(i, 0)      = (0.0_dp, 0.0_dp)
            end do

            do k = S-2, 0, -1
               !$OMP SIMD
               do i = 1, S-1
                  beta_z(i, k) = gammia(k+1) * (fci_over_omega * phi(i,j,k+1) - beta_z(i, k+1))
               end do
            end do

            do k = 1, S-1
               !$OMP SIMD
               do i = 1, S-1
                  q_z(i, k) = alpha(k-1)*q_z(i, k-1) + beta_z(i, k-1)
               end do
            end do

            do k = 1, S-1
               !$OMP SIMD
               do i = 1, S-1
                  phi(i, j, k) = q_z(i, k) - phi(i, j, k)
               end do
            end do
         end block
      end do
      !$OMP END PARALLEL DO
   end do

   close(12)
   deallocate(V, alpha, phi, gammia)
   deallocate(x_disc, y_disc, z_disc)

end program Resolucion
