set encoding utf8
set term gif animate enhanced font "Sans,12"

set output 'EspacioFases.gif'

set xra[-1:1]
set yra[-3:3]

pi = atan(1.0)*4.0
g = 9.8
l = 1.0
m = 5.0
theta_punto = 0.0
theta = pi/4.0


b = sqrt(m*g*l)
a = sqrt((1/2)*m*l**2)

Et = (0.5)*m* l**2 * (theta_punto)**2 + m*g*l*(1.0-cos(theta))


y(x) = +sqrt(abs((Et/((1.0/2.0)*m*l**2))-g*((1-cos(x))/((0.5)*l))))
u(x) = -sqrt(abs((Et/((1.0/2.0)*m*l**2))-g*((1-cos(x))/((0.5)*l))))


set xlabel 'θ'
set ylabel 'θ̇'


do for[a = 0:100]{
    plot "datos.dat" i 0:a u 2:3 t 'Curva Simulada' w points pt 7, \
          'datos.dat' u 2:(y($2)) t 'Curva Teórica' w line, \
          'datos.dat' u 2:(u($2)) t '' w line,

}

