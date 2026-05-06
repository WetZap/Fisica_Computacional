set term gif animate

set output 'Todo.gif'

set xra[0:15]
set yra[-200:63]

y0 =10
v0= 32
g = 9.8
set size square 
y(x)= y0 + v0*x - (g/2)*x**2
v(x) = v0 -g*x

do for[a = 0:100]{
    plot "datos.dat" i 0:a u 1:2 t 'Altura' w points pt 7, "datos.dat" i 0:a u 1:4 t 'Velocidad' w points pt 7, "datos.dat" i 0:a u 1:5 t 'Aceleración', "datos.dat" u 1:(y($1))  t 'y Teórica' with lines linewidth 2 linecolor "blue",'datos.dat' u 1:(v($1)) t 'v Teórica' with lines linewidth 2 linecolor "blue"}
