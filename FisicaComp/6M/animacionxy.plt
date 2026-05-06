set term gif animate

set output 'piedraxy.gif'

set xra[-1:1]
set yra[-1:1]


set size square 


do for[a = 0:100]{plot "datos.dat" i 0:a u 3:2}
