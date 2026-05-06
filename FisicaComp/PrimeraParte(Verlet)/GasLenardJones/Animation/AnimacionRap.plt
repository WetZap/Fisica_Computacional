# 2. Analizamos el archivo formateado
stats archivo_entrada nooutput

# 3. Configuración del motor de renderizado a PNG
set terminal pngcairo size 600,600 background "#ffffff" enhanced
set output archivo_salida

# 4. Estética
set size square
set xlabel "Tiempo"
set ylabel "Posición"

set xrange [0:15]

set style line 1 lc rgb '#1f77b4' pt 3 ps 1.5

set style line 2 lc rgb '#d91f1f' pt 3 ps 1.5

set style line 3 lc rgb '#21b41f' pt 2 ps 1.5


plot archivo_entrada u 1:2 with points ls 1 t "Kinetica"  , \
    archivo_entrada u 1:3 with points ls 2 t "Potencial" , \
    archivo_entrada u 1:4 with points ls 3 t "Total"



