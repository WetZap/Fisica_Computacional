program Ejercicio
   implicit none
   real*8 r, theta,theta_rad, pi, x,y
   integer i


   pi = 4.d0*datan(1.d0)
   r = 5.d0
   !El angulo de theta se dara en º y tendra que ser convertido a radianes para poder usar las funciones trigonométricas, por lo que se multiplica por pi/180
   theta = 30.d0

   theta_rad = (theta * pi) / 180.d0

   call coordenadas(r, theta_rad, x, y)
   print*, "El valor de x es: ", x
   print*, "El valor de y es: ", y
   !Incremento de theta 2pi/100



   open(10, file="coordenadas.dat", status="unknown")
   do i = 1,100
      theta_rad = theta_rad + 2.d0*pi/100.d0
      call coordenadas(r, theta_rad, x, y)
      print*, "El valor de x es: ", x, "y el valor de y es: ", y
      write(10,*) r, theta_rad, x, y
      write(10,*)
      write(10,*)
   end do

end program Ejercicio



subroutine coordenadas(r, theta, x, y)
   implicit none
   real*8 r, theta, x, y
   x = r * cos(theta)
   y = r * sin(theta)
   return
end subroutine coordenadas
