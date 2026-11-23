set terminal pngcairo size 800,600 enhanced font 'Verdana,10'

set output archivo_salida


 set xrange [0:120]
set yrange [-1:1]




plot archivo_entrada u 1:2 t"Momento angular"