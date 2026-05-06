program TareaEvaluable
   implicit none
   real*8 t,h,Longitud,densidad, limite_tiempo,paso_temporal,angulo,pi,modulo_v,num_aleatorio

   real*8, allocatable :: x(:),y(:),vx(:),vy(:),ax(:),ay(:),omega_x(:),omega_y(:), r(:)

   real*8,external::Densidadfun, distancia
   integer i,j,k,NumeroParticulas
   character(len=100) :: linea,valor_j, nombre_archivo_total
   paso_temporal = 0.002d0

   NumeroParticulas=100
   limite_tiempo=10.0d0
   Longitud = 22.0d0

   h = paso_temporal
   pi = 4.0d0*atan(1.0d0)
   modulo_v = 1.0d0
   densidad = Densidadfun(Longitud,NumeroParticulas)

   call random_seed()

   allocate(x(NumeroParticulas),y(NumeroParticulas),vx(NumeroParticulas),vy(NumeroParticulas),ax(NumeroParticulas),ay(NumeroParticulas),omega_x(NumeroParticulas),omega_y(NumeroParticulas), r(NumeroParticulas))
   do i = 1, NumeroParticulas
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') i
      nombre_archivo_total = 'Datos//datos_'//trim(adjustl(valor_j))//'.dat'
      open(20+i, file = nombre_archivo_total, status= 'unknown')
   end do


   do i = 1, NumeroParticulas

      call random_number(num_aleatorio)
      angulo = 2.0d0*pi*num_aleatorio
      vx(i) = modulo_v*cos(angulo)
      vy(i) = modulo_v*sin(angulo)

      call random_number(num_aleatorio)
      x(i) = Longitud*num_aleatorio

      call random_number(num_aleatorio)
      y(i) = Longitud*num_aleatorio
   end do

   do i = 1, NumeroParticulas
      r(i) = sqrt(x(i)**2+y(i)**2)

   end do

   do i = 1, NumeroParticulas
      ax(i) = 0.0d0
      ay(i) = 0.0d0
      do j = 1, NumeroParticulas
         if (r(j) > 3.0d0) then
            ax(i) = 0.0d0
            ay(i) = 0.0d0
         else

            ax(i) = ax(i) +((48/r(j))**7-(24/r(j))**4)* x(j)
            ay(i) = ay(i) +((48/r(j))**7-(24/r(j))**4)* y(j)
         end if
      end do

   end do

   t = 0.d0
   do while(t < limite_tiempo)
      do i = 1, NumeroParticulas
         write(20+i,*) t, x(i), y(i), vx(i), vy(i), ax(i), ay(i)
         omega_x(i) = vx(i) + (h/2.0d0)*ax(i)
         omega_y(i) = vy(i) + (h/2.0d0)*ay(i)
         x(i) = x(i) + h*omega_x(i)
         y(i) = y(i) + h*omega_y(i)

         do j = 1, NumeroParticulas
            r(i) = sqrt(x(i)**2+y(i)**2)

         end do

         do k = 1, NumeroParticulas
            ax(k) = 0.0d0
            ay(k) = 0.0d0
            do j = 1, NumeroParticulas
               if (r(j) > 3.0d0) then
                  ax(k) = 0.0d0
                  ay(k) = 0.0d0
               else
                  ax(k) = ax(k) +((48/r(j))**7-(24/r(j))**4)* x(j)
                  ay(k) = ay(k) +((48/r(j))**7-(24/r(j))**4)* y(j)
               end if
            end do

         end do



      end do
      do i = 1, NumeroParticulas
         vx(i) = omega_x(i) + (h/2.0d0)*ax(i)
         vy(i) = omega_y(i) + (h/2.0d0)*ay(i)
      end do
      t = t + h

   end do

   do i = 1, NumeroParticulas
      close(20+i)
   end do

   print *, 'Simulación finalizada'
end program TareaEvaluable


real*8 function densidadfun(Longitud,NumeroParticulas) result(densidad)
   implicit none
   real*8 Longitud
   integer NumeroParticulas
   densidad=NumeroParticulas/(Longitud**2)

end function densidadfun



