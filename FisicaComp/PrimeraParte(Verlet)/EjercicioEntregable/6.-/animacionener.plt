set encoding utf8
set term gif animate enhanced font "Sans,12"

set output 'EspacioEnergía4.gif'

set xra[0:10]
set yra[0:14]


set xlabel "t"
set ylabel "E"


do for[a = 0:100]{
    plot "datosenergia4.dat" i 0:a u 1:2 t 'Cinética' w linespoints pt 7, \
         "datosenergia4.dat" i 0:a u 1:3 t 'Potencial' w linespoints pt 7, \
         "datosenergia4.dat" i 0:a u 1:4 t 'Total' w linespoints pt 7 

}