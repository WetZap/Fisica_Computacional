program Tarea1
   implicit none
   integer i, N,j,k, ios
   real*8 r(0:1,11), v(0:1,11),a(0:1,11),M(11),omega(0:1,11)
   real*8 x, y, vx, vy,m_i
   real*8 h,c,t,Ms,Ms_m,G
   real *8, external::aceleracion

   character(len=100) :: linea,valor_j, nombre_archivo_total

! Definir constantes y variables
   G = 6.67d-11 ! Constante de gravitación universal
   Ms = 1.989d6 ! Elevado a 6 por dividir entre 2
   Ms_m = 1.989d30 ! Masa del Sol en kg
   t = 0.d0
   h = 0.01d0 ! Paso de tiempo
   N = 11 ! Numero de planetas
   c =1.496d11 ! Distancia media de la Tierra al Sol en metros

   open(10, file = 'Datos/planetas.dat', status= 'old')

   do i = 1, N
      read(10, '(A)', iostat=ios) linea
      if (ios /= 0) then
         print *, "Error de formato leyendo la linea. IOSTAT =", ios
         exit
      end if
      read(linea, *) x, y, vx, vy
      r(0,i) = (x*10**9)/c
      r(1,i) = (y*10**9)/c
      v(0,i) = (vx*10**3 ) * dsqrt(c/(G*Ms_m))
      v(1,i) = (vy * 10**3) * dsqrt(c/(G*Ms_m))

   end do
   close(10)
   print*,r(:,:)


   open(10, file = 'Datos/Masas.dat', status= 'old')

   do i = 1, N
      read(10, *, iostat=ios) m_i
      if (ios /= 0) then
         print *, "Error de formato leyendo la linea. IOSTAT =", ios
         exit
      end if
      print *, "Masa del planeta ", i, ": ", m_i, " kg"
      M(i) = (m_i)/Ms! Masa de cada planeta en unidades de la masa del Sol
   end do
   close(10)

   do k = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') k
      nombre_archivo_total = 'Datos/datos_out_'//trim(adjustl(valor_j))//'.dat'
      open(20+k, file = nombre_archivo_total, status= 'unknown')
   end do
   do i = 1,N
      a(0,i) = 0.d0
      a(1,i) = 0.d0
      do j = 1, N
         if (i/=j)then
            a(0,i) = a(0,i) - (M(j)*(r(0,i)-r(0,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
            a(1,i) = a(1,i) - (M(j)*(r(1,i)-r(1,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
         end if
      end do
   end do
   t = 0.d0
   do while (t <= 10.d0)

      do k = 1,N
         write(20+k,*) t, r(0,k), r(1,k), v(0,k), v(1,k), a(0,k), a(1,k)
         write(20+k,*)
         write(20+k,*)
         omega(0,k) = v(0,k) + (h/2.d0)*a(0,k)
         omega(1,k) = v(1,k) + (h/2.d0)*a(1,k)

         r(0,k) = r(0,k) + h*omega(0,k)
         r(1,k) = r(1,k) + h*omega(1,k)

         do i = 1,N
            a(0,i) = 0.d0
            a(1,i) = 0.d0

            do j = 1, N
               if (i/=j)then
                  a(0,i) = a(0,i) - (M(j)*(r(0,i)-r(0,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
                  a(1,i) = a(1,i) - (M(j)*(r(1,i)-r(1,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
               end if
            end do

         end do

         v(0,k) = omega(0,k) + (h/2.d0)*a(0,k)
         v(1,k) = omega(1,k) + (h/2.d0)*a(1,k)

      end do
      t = t+h

   end do
   do k = 1,N
      close(20+k)
   end do
end program Tarea1

function aceleracion() result(valor)
   implicit none
   real*8 valor

end function
