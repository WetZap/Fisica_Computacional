program EjercicioEntregable
   implicit none
   real*8 theta,t, theta_punto, theta_doble_punto, x, y,h, omega, enercin, enerpo, enerme, periodo,periodo_ini,tiempo,periodo2, energiatotal,theta_inicial,theta_ant, limite_t_superior,periodo_relativo,periodo_medio
   real*8,allocatable :: theta_ini(:),theta_punto_ini(:)

   character(len=50) :: nombre_archivo_total, nombre_archivo_energia, valor_j,linea
   integer i,j,cont,longitud,media
   real*8 g, l, m, pi !Constantes

   !Definimos los valores que tendran las constantes
   g = 9.8
   l = 1.d0
   m = 1.d0
   pi = datan(1.d0)*4.d0
   limite_t_superior = 10.d0
   h = 0.01d0


   !Llamamos a la rutina que se encarga de rellenar los vectores a partir de los valores de Iniciales.dat
   call leer_datos(theta_ini, theta_punto_ini, longitud)

   ! Comenzamos un bucle con la longitud del vector de theta pq es un vector que se llena
   ! y define su longitud durante la ejecución
   do j = 1,longitud
      ! Tranformamos el vector j en un string
      write(valor_j, '(I10)') j

      ! Definimos los nombres de los archivos que guardaremos
      nombre_archivo_total = 'Datos/datos'//trim(adjustl(valor_j))//'.dat'
      nombre_archivo_energia = 'Datos/Energias/datosenergia'//trim(adjustl(valor_j))//'.dat'

      ! Cogemos los valores iniciales para cada momento del bucle de j
      ! así como calcular el valor de la aceleración angular
      theta_punto = theta_punto_ini(j)
      theta = theta_ini(j)*pi
      theta_doble_punto = -(g/l)*sin(theta)

      ! Iniciamos el valor del tiempo a 0
      t = 0.d0

      cont = 0

      open(10, file = nombre_archivo_total, status= 'unknown')
      open(11, file = nombre_archivo_energia, status= 'unknown')

      !Calculamos el periodo inicial para comparar con el periodo obtenido
      periodo_ini = 2.d0*pi*dsqrt(l/g)


      !Calculamos la energía total para compararla con la energía mecánica
      energiatotal =(1.d0/2.d0)*m* l**2 * (theta_punto)**2 + m*g*l*(1d0-cos(theta))

      if (j==6) then
         limite_t_superior = 20.d0
      else
         limite_t_superior = 10.d0
      end if

      do while (t< limite_t_superior)
         ! Calculamos los valores de x e y como función de theta y L
         x =  l*sin(theta)
         y = -l*cos(theta)
         !Calculamos las energías


         enercin = (1.d0/2.d0)*m*(theta_punto*l)**2
         enerpo =m*g*l*(1-cos(theta))
         enerme = enercin + enerpo


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

         t = t + h
      end do
      ! Cerramos los archivos para abrir el siguiente
      close(10)
      close(11)
   end do
   open(14, file='Periodos.dat', status='unknown')

   do j = 2,longitud
      ! Tranformamos el vector j en un string
      write(valor_j, '(I10)') j

      ! Definimos los nombres de los archivos que guardaremos
      nombre_archivo_total = 'Datos/datos'//trim(adjustl(valor_j))//'.dat'


      open(10, file = nombre_archivo_total, status= 'old')
      read(10, *) t, theta
      theta_inicial = theta
      tiempo = 0.d0
      cont = 0
      do
         read(10, *, iostat=i) t, theta
         if (i /= 0) exit
         if ((theta < 0.d0.and.theta_ant >= 0.d0).or.(theta > 0.d0.and.theta_ant <= 0.d0)) then
            if (cont == 0) then
               tiempo = t
               cont = cont +1
            else if (cont == 1) then
               periodo2 = (t-tiempo)
               cont = 0
               write(14,*) theta_inicial, periodo2, periodo2/periodo_ini
            end if

         end if
         theta_ant = theta
      end do
      close(10)
   end do
   close(14)
   open(15, file='Periodos.dat', status='old')
   open(16, file='PeriodosAjuste.dat', status='unknown')

   cont = 0
   theta_ant = 0.d0
   media = 0.d0
   periodo_medio = 0.d0
   do
      read(15, *, iostat=i)theta_inicial, periodo2, periodo_relativo
      ! Mejor control de errores para identificar el problema exacto
      if (i < 0) exit ! Fin de archivo detectado correctamente (EOF)
      if (i > 0) then
         print *, "Error de formato leyendo la linea. IOSTAT =", i
         exit
      end if
      if (cont == 0) then
         theta_ant = theta_inicial
         cont = 1
      endif

      if (abs(theta_ant - theta_inicial) < 1.d-7) then
         media = media + 1
         periodo_medio = periodo_medio + periodo2

      else

         write(16,*) theta_ant, periodo_medio/media
         media = 1.d0
         periodo_medio = periodo2

      end if
      theta_ant = theta_inicial
   end do

   close(15)
   close(16)
   print*, "Correcto2"



contains
   subroutine leer_datos(theta_ini, theta_punto_ini, longitud)
      implicit none
      character(len=100) :: linea, temp
      character(len=20) :: col1, col2
      real*8 :: val1, val2, num, den
      real*8,allocatable,intent(out) :: theta_ini(:),theta_punto_ini(:)
      integer,intent(out) :: longitud

      integer :: p_espacio, p_barra, iostat,k
      longitud= 0
      open(12, file='Iniciales.dat', status='old')
      do
         ! Leemos la línea completa (A) para que Fortran no evalúe nada
         read(12, '(A)', iostat=iostat) linea
         if (iostat /= 0) exit
         longitud = longitud +1

      end do
      close(12)

      allocate(theta_ini(longitud))
      allocate(theta_punto_ini(longitud))

      open(12, file='Iniciales.dat', status='old')

      k= 1
      ! Bucle para leer todas las líneas del archivo
      do
         ! Leemos la línea completa (A) para que Fortran no evalúe nada
         read(12, '(A)', iostat=iostat) linea
         if (iostat /= 0) exit  ! Sale del bucle si llegamos al final del archivo

         temp = adjustl(linea)

         p_espacio = index(temp, ' ')

         if (p_espacio > 0) then
            ! 3. Cortamos la cadena en dos trozos manualmente
            col1 = temp(1:p_espacio-1)
            col2 = temp(p_espacio+1:)

            ! 4. Evaluamos la primera columna buscando la fracción
            p_barra = index(col1, '/')
            if (p_barra > 0) then
               read(col1(1:p_barra-1), *) num
               read(col1(p_barra+1:), *) den
               val1 = num / den
            else
               read(col1, *) val1
            end if

            ! 5. Evaluamos la segunda columna buscando la fracción
            p_barra = index(col2, '/')
            if (p_barra > 0) then
               read(col2(1:p_barra-1), *) num
               read(col2(p_barra+1:), *) den
               val2 = num / den
            else
               read(col2, *) val2
            end if



            theta_ini(k) = val1
            theta_punto_ini(k) = val2
            k = k + 1
         end if
      end do

      close(12)
   end subroutine leer_datos



end program EjercicioEntregable

