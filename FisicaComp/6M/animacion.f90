program Piedra
   implicit none
   real*8 t, v0, g, v,y0,y,x
   integer i
   g = 9.8
   x = 0.d0
   v0 = 32.d0
   y0 = 10.d0
   t = 0.d0


   open(10, file = 'datos.dat', status= 'old')
   do while( i< 50)
      t =t + i/100.d0

      y = y0 + v0*t - (g/2.d0)*t**2
      v = v0 - g *t
      write(10,*)t,y ,x,v,g
      write(10,*)
      write(10,*)
      i= i+1

   end do
   close(10)

end program Piedra
