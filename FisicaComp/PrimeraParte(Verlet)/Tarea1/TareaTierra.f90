program Tierra
   implicit none
   real*8 x,y, x_tierra,y_tierra,t,m_i, tiempo_entrada,h,t_pri
   integer i, N, j, k, ios,cont
   character(len=100) :: valor_j, nombre_archivo_total

   N = 10 ! Numero de planetas

   tiempo_entrada = 240.d0
   h = 0.0001d0
   open(10, file = 'Datos/Inicial/Masas.dat', status= 'old')
   cont = 0
   do i = 1, N
      read(10, *, iostat=ios) m_i
      if (ios /= 0) exit
      print *, "Leyendo masa del planeta ", i, ": ", m_i
      cont = cont +1

      if (abs(m_i-5.97) < 1.0e-6) exit
   end do
   close(10)
   print *, "El planeta Tierra es el numero ", cont, " en la lista de planetas"

   do k = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') k
      nombre_archivo_total = 'Datos/DatosOut/datos_out_'//trim(adjustl(valor_j))//'.dat'
      open(20+k, file = nombre_archivo_total, status= 'unknown')
   end do
   do k = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') k
      nombre_archivo_total = 'Datos/Tierra/datos_out__Tierra'//trim(adjustl(valor_j))//'.dat'
      open(50+k, file = nombre_archivo_total, status= 'unknown')

   end do
   t = 0.d0
   do while (t < tiempo_entrada)
      read(20+cont, *, iostat=ios)t_pri, x_tierra, y_tierra
      if (ios /= 0) exit
      do i = 1, N
         read(20+i, *, iostat=ios) t_pri, x,y
         if (ios /= 0) exit

         write(50+i,*) t_pri, x-x_tierra, y-y_tierra
         write(50+i,*)
         write(50+i,*)

      end do
      t = t + h
   end do

   do i = 1, N
      close(20+i)
      close(50+i)
   end do


end program Tierra
