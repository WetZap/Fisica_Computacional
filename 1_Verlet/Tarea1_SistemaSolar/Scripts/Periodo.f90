program Periodo
   implicit none
   integer i, N, j, k, ios,cont


   real*8 t,x,y,x_ant,y_ant,tiempo,per,peri
   character(len=100) :: valor_j, nombre_archivo_total

   N = 10

   do i = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') i
      nombre_archivo_total = 'Datos/DatosOut/datos_out_'//trim(adjustl(valor_j))//'.dat'
      open(20+i, file = nombre_archivo_total, status= 'unknown')
      open(50+i, file = 'Datos/Periodos/periodos_'//trim(adjustl(valor_j))//'.dat', status= 'unknown')

   end do
   do i = 1,N
      cont = 0
      y_ant = 0.d0

      tiempo = 0.d0
      do
         read(20+i, *, iostat=ios) t, x,y
         if (ios /= 0) exit
         if (cont == 0) then
            tiempo = t
            cont = cont + 1
         end if
         if ((cont == 1 ).and. ((y > 0.d0 .and. y_ant < 0.d0))) then

            per = (t-tiempo)
            cont = 0
            write(50+i,*) per, per*58.0604

         end if
         y_ant = y

      end do
   end do




   do i = 1, N
      close(20+i)
      close(50+i)

   end do







   do i = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') i
      nombre_archivo_total = 'Datos/DatosOut/datos_out_'//trim(adjustl(valor_j))//'.dat'
      open(50+i, file = 'Datos/Periodos/periodos_'//trim(adjustl(valor_j))//'.dat', status= 'unknown')
   end do


   open(100, file = 'Datos/Inicial/periodos.dat', status= 'unknown')
   open(101, file = 'Datos/Periodos/PeriodosError.dat', status= 'unknown')

   do i = 2, 8
      read(50+i, *, iostat=ios) t, per
      if (ios /= 0) exit
      read(100, *, iostat=ios) peri
      print*, "Periodo: ", per, " Periodo teorico: ", peri
      write(101,*) per, abs(per-peri)/peri *100.d0

   end do

   do i = 1, N
      close(50+i)

   end do
   close(100)
   close(101)



   print*, "Correcto"

end program Periodo
