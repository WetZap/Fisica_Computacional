program Tarea1
   implicit none
   integer i, N,j,k, ios,cont
   real*8 r(0:1,10), v(0:1,10),a(0:1,10),M(10),omega(0:1,10), r_luna(0:1), v_luna(0:1), a_luna(0:1), omega_luna(0:1)
   real*8 x, y, vx, vy,m_i, masa_luna, Energia_cinetica, Energia_potencial, Energia_total, Momento_angular
   real*8 h,c,t,Ms,Ms_m,G, limite_tiempo,t_prim

   character(len=100) :: linea,valor_j, nombre_archivo_total

! Definir constantes y variables
   G = 6.67d-11 ! Constante de gravitación universal
   Ms = 1.989d6 ! Elevado a 6 por dividir entre 24
   Ms_m = 1.989d30 ! Masa del Sol en kg
   t = 0.d0 ! Variable de tiempo
   h = 0.001d0 ! Paso de tiempo
   N = 10 ! Numero de planetas
   c =1.496d11 ! Distancia media de la Tierra al Sol en metros
   limite_tiempo = 1200.d0 ! Tiempo máximo de simulación
   ! Abrimos el archivo que contiene las posiciones y velocidades iniciales de los planetas

   ! Abrimos el archivo que contiene las posiciones y velocidades iniciales de los planetas
   open(10, file = 'Datos/Inicial/planetas.dat', status= 'old')
   open(99, file = 'Datos/EnergiaMomento/Energia.dat', status= 'unknown')
   open(100, file = 'Datos/EnergiaMomento/Momento_angular.dat', status= 'unknown')

   ! Leemos las posiciones y velocidades iniciales de los planetas desde el archivo
   do i = 1, N
      read(10, '(A)', iostat=ios) linea
      if (ios /= 0) then
         print *, "Error de formato leyendo la linea. IOSTAT =", ios
         exit
      end if
      read(linea, *) x, y, vx, vy
      ! Corregimos las unidades de las posiciones y las velocidades para que estén en el sistema de unidades que estamos utilizando
      r(0,i) = (x*10**9)/c
      r(1,i) = (y*10**9)/c
      v(0,i) = (vx*10**3 ) * dsqrt(c/(G*Ms_m))
      v(1,i) = (vy * 10**3) * dsqrt(c/(G*Ms_m))
      print *, "Planeta ",i, ": Posición Inicial (", r(0,i), ", ", r(1,i), ") y Velocidad Inicial (", v(0,i), ", ", v(1,i), ")"
   end do
   close(10)

   ! Abrimos el archivo que contiene las masas de los planetas
   open(10, file = 'Datos/Inicial/Masas.dat', status= 'old')

   ! Leemos las masas de los planetas desde el archivo
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



   do i = 1, N
      ! Definimos los nombres de los archivos que guardaremos
      write(valor_j, '(I10)') i
      nombre_archivo_total = 'Datos/DatosOut/datos_out_'//trim(adjustl(valor_j))//'.dat'
      open(20+i, file = nombre_archivo_total, status= 'unknown')
   end do


! Calculamos las aceleraciones iniciales de los planetas debido a la gravedad
   do i = 1,N
      ! Inicializamos las aceleraciones a cero antes de calcularlas pq las calculamos como una suma
      a(0,i) = 0.d0
      a(1,i) = 0.d0
      do j = 1, N
         if (i/=j)then
            a(0,i) = a(0,i) - (M(j)*(r(0,i)-r(0,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
            a(1,i) = a(1,i) - (M(j)*(r(1,i)-r(1,j)))/(((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2)**(3.d0/2.d0))
         end if
      end do
   end do
   print *,a(0,2),a(1,2), a(0,3) , a(1,3)
   ! Comenzamos ek bucle temporal del Algortimo, alcanzara el valor de tiempo definido en limite_tiempo
   t = 0.d0
   do while (t <= limite_tiempo)! Avanzara en función del valor de h

      !Calculo de la Energía
      Energia_cinetica = 0.d0
      do i = 1, N
         Energia_cinetica = Energia_cinetica + (0.5*M(i)*((v(0,i))**2+(v(1,i))**2))
      end do
      Energia_potencial = 0.d0

      do i = 1, N
         do j = i+1, N
            Energia_potencial = Energia_potencial - (M(i)*M(j))/(dsqrt((r(0,i)-r(0,j))**2+(r(1,i)-r(1,j))**2))
         end do
      end do

      write(99,*) t, Energia_cinetica ,Energia_potencial, Energia_cinetica + Energia_potencial
      ! Calculo del momento angular
      Momento_angular = 0.d0
      do i = 1, N
         !Momento_angular = Momento_angular + M(i)*((dsqrt((r(0,i))**2+(r(1,i))**2))*dsqrt((v(0,i))**2+(v(1,i))**2))
         Momento_angular = Momento_angular + M(i)*((r(0,i)*v(1,i))-(r(1,i)*v(0,i)))
      end do
      write(100,*) t, Momento_angular




      ! Comenzamos el bucle que actualizara las posiciones y velocidades de cada planeta, y guardara los datos en los archivos correspondientes
      do k = 1,N
         ! Introducimos los datos en los archivos correspondientes
         write(20+k,*) t, r(0,k), r(1,k), v(0,k), v(1,k), a(0,k), a(1,k)
         write(20+k,*)
         write(20+k,*)

         ! Calculamos los valores de omega en funcion de las velocidades y aceleraciones actuales, para luego actualizar las posiciones
         omega(0,k) = v(0,k) + (h/2.d0)*a(0,k)
         omega(1,k) = v(1,k) + (h/2.d0)*a(1,k)

         ! Recalculamos las posiciones de cada planeta en función de los valores de omega calculados
         r(0,k) = r(0,k) + h*omega(0,k)
         r(1,k) = r(1,k) + h*omega(1,k)

         ! Volvemos a calcular las aceleraciones de cada planeta en función de las nuevas posiciones, para luego actualizar las velocidades
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



      end do
      ! Finalmente, actualizamos las velocidades de cada planeta en función de los valores de omega y las nuevas aceleraciones calculadas
      do k = 1,N
         v(0,k) = omega(0,k) + (h/2.d0)*a(0,k)
         v(1,k) = omega(1,k) + (h/2.d0)*a(1,k)
      end do

      ! Actualizamos el tiempo en función del paso de tiempo definido
      t = t+h

   end do


   ! Cerramos los archivos que contienen los datos de cada planeta
   do k = 1,N
      close(20+k)
   end do
   ! Ahora vamos a incluir la Luna en el sistema, para esto, abrimos el archivo que contiene las masas de los planetas para obtener la masa de la Tierra, y luego abrimos el archivo en el que guardaremos los valores de la Luna. Para ello primero encontramos la masa de la Tierra

   open(10, file = 'Datos/Inicial/Masas.dat', status= 'old')
   cont = 0
   do i = 1, N
      read(10, *, iostat=ios) m_i
      if (ios /= 0) then
         print *, "Error de formato leyendo la linea. IOSTAT =", ios
         exit
      end if
      if (abs(m_i-5.97) < 1.0e-5) exit
      cont = cont + 1
   end do
   close(10)

   open(10, file = "Datos/DatosOut/Luna.dat", status= 'unknown')
   open(11, file = 'Datos/DatosOut/datos_out_4.dat', status= 'old')

   ! Definimos las condiciones iniciales de la Luna, considerando que se encuentra a una distancia media de la Tierra y con una velocidad orbital correspondiente a esa distancia
   r_luna(0) = ((0.384*10**9)/c)
   r_luna(1) = 0.d0
   v_luna(0) = 0.d0
   v_luna(1) = ((1.d0)*10**3) * dsqrt(c/(G*Ms_m)) ! Velocidad orbital de la Luna en m/s
   a_luna(0) = 0.d0
   a_luna(1) = 0.d0

   print*, "Condiciones iniciales de la Luna: Posición (", r_luna(0), ", ", r_luna(1), ") y Velocidad (", v_luna(0), ", ", v_luna(1), ")"

   masa_luna =(0.073+m_i)/Ms ! Masa de la Luna
   ! Realizamos el mismo bucle temporal que para los planetas pero solo teniendo en cuenta la influencia de la tierra sobre la Luna, y guardando los datos de la Luna en el archivo correspondiente.

   t = 0.d0
   do while (t <= limite_tiempo)
      ! Leemos los datos de la Tierra desde el archivo correspondiente, para tener en cuenta su influencia sobre la Luna
      read(11,*) t_prim,r(0,cont), r(1,cont), v(0,cont), v(1,cont), a(0,cont), a(1,cont)

      ! Calculamos la aceleración de la Luna debido a la gravedad de la Tierra
      a_luna(0) = - (masa_luna*(r_luna(0)))/(((r_luna(0))**2+(r_luna(1))**2)**(3.d0/2.d0))
      a_luna(1) = - (masa_luna*(r_luna(1)))/(((r_luna(0))**2+(r_luna(1))**2)**(3.d0/2.d0))

      ! Guardamos los datos de la Luna en el archivo correspondiente
      write(10,*) t, r_luna(0) + r(0,cont), r_luna(1) + r(1,cont), v_luna(0), v_luna(1), a_luna(0), a_luna(1)
      write(10,*)
      write(10,*)


      ! Realizamos el proceso del algoritmo de Verlet.
      omega_luna(0) = (v_luna(0)) + (h/2.d0)*a_luna(0)
      omega_luna(1) = (v_luna(1)) + (h/2.d0)*a_luna(1)

      r_luna(0) = r_luna(0)  + h*omega_luna(0)
      r_luna(1) = r_luna(1) + h*omega_luna(1)

      a_luna(0) =  - (masa_luna*(r_luna(0)))/(((r_luna(0))**2+(r_luna(1))**2)**(3.d0/2.d0))
      a_luna(1) =  - (masa_luna*(r_luna(1)))/(((r_luna(0))**2+(r_luna(1))**2)**(3.d0/2.d0))

      v_luna(0) = omega_luna(0) + (h/2.d0)*a_luna(0)
      v_luna(1) = omega_luna(1) + (h/2.d0)*a_luna(1)

      t = t+h
   end do

   close(10)
   close(11)
   close(99)
   close(100)

   print*, "Correcto"
end program Tarea1


