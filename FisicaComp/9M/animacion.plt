set encoding utf8
set term gif animate enhanced font "Sans,12"

set output 'Todo.gif'

set xra[0:10]
set yra[-10:10]

set xlabel 'tiempo'
set ylabel 'Variables'


do for[a = 0:500]{
    plot "datos.dat" i 0:a u 1:2 t 'θ' w points pt 7, \
         "datos.dat" i 0:a u 1:3 t 'θ̇' w points pt 7, \
         "datos.dat" i 0:a u 1:4 t 'θ̈', \
         "datos.dat" i 0:a u 1:5 t 'x(t)', \
         "datos.dat" i 0:a u 1:6 t 'y(t)'
}