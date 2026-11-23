program RungeKuta
   implicit none
   real*8 t, h, limite_tiempo, latitud,distancia_L, Radio_Tierra, Radio_Luna, G, M_Tierra, r_inicial, M_Luna, Hamiltoniano, H_prima
   real*8 theta, phi, pi, r, p_r, p_phi, velocidad, omega, delta, mu, r_tilda
   real * 8, dimension(:), allocatable :: k_1, k_2, k_3, k_4
   real*8, external :: f_r, f_phi, f_pr, f_pphi
   integer i, N,cont


   N = 4
   allocate(k_1(1:4), k_2(1:4), k_3(1:4), k_4(1:4))
   ! Inicializacion de variables
   pi = 4.d0 * datan(1.d0)
   G = 6.67430d-11
   M_Tierra = 5.972d24
   M_Luna   = 7.348d22
   distancia_L = 3.844d8
   Radio_Tierra = 6371000.d0
   Radio_Luna = 1737000.d0
   omega = 2.6617d-6
   cont = 0


   latitud = pi/4.d0
   theta = pi/2.d0
   velocidad = 14000.d0


   mu = M_Luna / M_Tierra
   delta = G * M_Tierra / distancia_L**3
   r_inicial = Radio_Tierra



   !Reescalamos los valores y calculamos las condiciones iniciales:
   r = r_inicial / distancia_L

   phi = latitud

   p_r = (velocidad /distancia_L) * cos(theta - latitud)

   p_phi = r * (velocidad /distancia_L) * sin(theta - latitud)



   t = 0.d0
   limite_tiempo = 1000000.d0
   h = 0.1d0

   open(10, file="Data/Tarea3/RungeKutta_r.dat", status="replace")
   open(11, file="Data/Tarea3/RungeKutta_phi.dat", status="replace")
   open(12, file="Data/Tarea3/RungeKutta_pr.dat", status="replace")
   open(13, file="Data/Tarea3/RungeKutta_pphi.dat", status="replace")
   open(14, file="Data/Tarea3/RungeKutta_orbita.dat", status="replace")
   open(15, file="Data/Tarea3/RungeKutta_orbita_Luna.dat", status="replace")
   open(16, file="Data/Tarea3/RungeKutta_energia.dat", status="replace")

   print*, "Iniciales: r = ", r, " phi = ", phi, " p_r = ", p_r, " p_phi = ", p_phi

   do while(t<limite_tiempo)
      Hamiltoniano = p_r**2/2.d0 + p_phi**2/(2.d0*r**2) - delta * (1/r + mu/sqrt(r**2 + 1 - 2*r*cos(phi-omega*t)))
      H_prima = Hamiltoniano - omega * p_phi
      if (cont == 10000) then
         write(10,*) t, r
         write(11,*) t, phi
         write(12,*) t, p_r
         write(13,*) t, p_phi
         write(14,*) r*cos(phi), r*sin(phi)
         write(15,*) cos(omega*t), sin(omega*t)
         write(16,*) t, Hamiltoniano, H_prima

         write(10,*);write(11,*);write(12,*);write(13,*);write(14,*);write(15,*);write(16,*)
         write(10,*);write(11,*);write(12,*);write(13,*);write(14,*);write(15,*);write(16,*)
         cont = 0
      end if
      cont = cont + 1



      ! Calculamos los valores de k
      k_1(1) = h * f_r(p_r,omega)
      k_1(2) = h * f_phi(r,p_phi,omega)
      k_1(3) = h * f_pr(r, phi, p_r, p_phi, t, omega)
      k_1(4) = h * f_pphi(r, phi, p_r, p_phi, t, omega)

      k_2(1) = h *f_r(p_r + k_1(3)/2,omega)
      k_2(2) = h *f_phi(r +k_1(1)/2.d0 ,p_phi + k_1(4)/2,omega)
      k_2(3) = h *f_pr(r +k_1(1)/2.d0, phi + k_1(2)/2.d0, p_r + k_1(3)/2.d0, p_phi + k_1(4)/2.d0, t+h/2, omega)
      k_2(4) = h *f_pphi(r +k_1(1)/2.d0, phi + k_1(2)/2.d0, p_r + k_1(3)/2.d0, p_phi + k_1(4)/2.d0, t+h/2, omega)

      k_3(1) = h *f_r(p_r + k_2(3)/2,omega)
      k_3(2) = h *f_phi(r +k_2(1)/2.d0 ,p_phi + k_2(4)/2,omega)
      k_3(3) = h *f_pr(r +k_2(1)/2.d0, phi + k_2(2)/2.d0, p_r + k_2(3)/2.d0, p_phi + k_2(4)/2.d0, t+h/2, omega)
      k_3(4) = h *f_pphi(r +k_2(1)/2.d0, phi + k_2(2)/2.d0, p_r + k_2(3)/2.d0, p_phi + k_2(4)/2.d0, t+h/2, omega)

      k_4(1) = h *f_r(p_r + k_3(3),omega)
      k_4(2) = h *f_phi(r +k_3(1) ,p_phi + k_3(4),omega)
      k_4(3) = h *f_pr(r +k_3(1), phi + k_3(2), p_r + k_3(3), p_phi + k_3(4), t+h, omega)
      k_4(4) = h *f_pphi(r +k_3(1), phi + k_3(2), p_r + k_3(3), p_phi + k_3(4), t+h, omega)


      ! Actualizamos los valores de r, phi, p_r y p_phi
      r = r + (1.d0/6.d0) * (k_1(1) + 2*k_2(1) + 2*k_3(1) + k_4(1))
      phi = phi + (1.d0/6.d0) * (k_1(2) + 2*k_2(2) + 2*k_3(2) + k_4(2))
      p_r = p_r + (1.d0/6.d0) * (k_1(3) + 2*k_2(3) + 2*k_3(3) + k_4(3))
      p_phi = p_phi + (1.d0/6.d0) * (k_1(4) + 2*k_2(4) + 2*k_3(4) + k_4(4))


      t = t+h
   end do






   close(10);close(11);close(12);close(13);close(14);close(15);close(16)

end program RungeKuta
function f_r(p_r,omega) result(f)
   real*8 p_r, omega
   real*8 f

   f = p_r

end function f_r

function f_phi(r, p_phi,omega) result(f)
   real*8 r, p_phi, omega
   real*8 f

   f = p_phi / r**2

end function f_phi

function f_pr(r, phi, p_r, p_phi,t,omega) result(f)
   real*8 p_r, p_phi, r, phi, r_tilda, t, omega
   real*8 f, mu, delta

   mu = 7.348d22 / 5.972d24
   delta = 6.67430d-11 * 5.972d24 / (3.844d8)**3
   r_tilda = sqrt(r**2 + 1 - 2*r*cos(phi-omega*t))

   f = (p_phi**2 / r**3)- delta *((1.d0/r**2)+ (mu/r_tilda**3)*(r-cos(phi-omega*t)))

end function f_pr

function f_pphi(r, phi, p_r, p_phi,t,omega) result(f)
   real*8 p_r, p_phi, r, phi, r_tilda, t, omega
   real*8 f, mu, delta

   mu = 7.348d22 / 5.972d24
   delta = 6.67430d-11 * 5.972d24 / (3.844d8)**3
   r_tilda = sqrt(r**2 + 1 - 2*r*cos(phi-omega*t))

   f = - mu * delta * r * sin(phi-omega*t) / r_tilda**3

end function f_pphi
