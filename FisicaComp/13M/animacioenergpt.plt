set encoding utf8
set term gif animate enhanced font "Sans,12" delay 10
set output 'EspacioEnergía_Apilada.gif'

set xra[0:10]
set yra[0:20]
set xlabel "t"
set ylabel "E"

# Estilo para áreas rellenas con cierta transparencia
set style fill transparent solid 0.7 noborder

do for [a=1:500]{
    plot "datosenergia.dat" every ::0::a u 1:4 t 'Total (Cinética + Potencial)' w filledcurves x1 lc rgb "#FF9999", \
         "datosenergia.dat" every ::0::a u 1:3 t 'Potencial' w filledcurves x1 lc rgb "#9999FF", \
         "datosenergia.dat" every ::0::a u 1:4 t 'Línea Total' w lines lw 3 lc rgb "black"
}
