program Algoritmo
   implicit none
   real*8 theta,t, theta_punto, theta_doble_punto, x, y,h, omega, enercin, enerpo, enerme, periodo,periodo_ini,tiempo,periodo2, energiatotal

   integer i,cont
   real*8 g, l, m,pi
   !Definimos los valores que tendran las constantes y las variables iniciales
   g = 9.8
   l = 1.d0
   m = 5.d0
   pi = datan(1.d0)*4.d0
   theta_punto = 0.d0
   theta = pi/4.d0
   t = 0.d0
   h = 0.05d0
   cont = 0

   !Calculamos el periodo inicial para comparar con el periodo obtenido
   periodo_ini = 2.d0*pi*dsqrt(l/g)
   !Calculamos la energía total para compararla con la energía mecánica
   energiatotal =(1.d0/2.d0)*m* l**2 * (theta_punto)**2 + m*g*l*(1d0-cos(theta))
   open(10, file = 'datos2.dat', status= 'unknown')
   open(11, file = 'datosenergia2.dat', status= 'unknown')


   do while (t< 10.d0)
      ! Calculamos los valores de x e y como función de theta y L
      x = l*sin(theta)
      y = -l*cos(theta)
      !Calculamos las energías
      enercin = (1.d0/2.d0)*m*(theta_punto*l)**2
      enerpo =m*g*l*(1-cos(theta))
      enerme = enercin + enerpo


      !Preguntar al profesor si es necesario calcular el periodo dentro del computo o se pueden usar los datos para obtenerlo posteriormente.


      !Buscamos el periodo
      if (abs(x)<0.02d0.and.(abs(y)+0.01)>1.d0) then
         if (cont==0 )then
            tiempo = t
            cont = cont +1
         end if
         if (cont ==1.and.t/=tiempo) then
            periodo = 2.d0*(t-tiempo)
            cont = cont + 1
            print*,"Periodo: ", periodo
            print*, "Periodo", periodo/periodo_ini
         end if
      end if

      !Escribimos los valores en un archivo para graficar posteriormente
      write(10,*) t, theta,theta_punto,theta_doble_punto,x,y, enercin, enerpo, enerme
      write(10,*)
      write(10,*)

      write(11,*)t, enercin,enerpo,enerme


      !Calculamos la función como F(theta)
      theta_doble_punto = -(g/l)*sin(theta)
      !Calculo el factor de omega
      omega = theta_punto + (h/2.d0)*theta_doble_punto
      ! Calclulo el nuevo valor de theta
      theta = theta + h*omega
      !Vuelvo a obtener el valor de theta doble punto
      theta_doble_punto = - (g/l)*sin(theta)

      theta_punto = omega + (h/2.d0)*theta_doble_punto

      t = t+h
   end do
   close(10)
   close(11)

   print*, "Correcto2"
end program Algoritmo

