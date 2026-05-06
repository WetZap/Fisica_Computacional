set encoding utf8
set term gif animate enhanced font "Sans,12"

set output 'EspacioEnergía.gif'

set xra[0:10]
set yra[0:20]


set xlabel "t"
set ylabel "E"


do for[a = 0:100]{
    plot "datosenergia.dat" i 0:a u 1:2 t 'Cinética' w line pt 7, \
         "datosenergia.dat" i 0:a u 1:3 t 'Potencial' w line pt 7, \
         "datosenergia.dat" i 0:a u 1:4 t 'Total' w line pt 7 

}