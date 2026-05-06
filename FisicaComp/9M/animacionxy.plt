set term gif animate

set output 'Pendulo.gif'

set xra[-1:1]
set yra[-1:1]


do for[a = 0:100]{plot "datos.dat" i a u 5:6 t 'Pendulo' w points pt 7}