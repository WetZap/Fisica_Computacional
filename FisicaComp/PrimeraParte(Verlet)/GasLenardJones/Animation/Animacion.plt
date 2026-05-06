# 2. Analizamos el archivo formateado
stats archivo_entrada nooutput
num_frames = int(STATS_blocks)
print sprintf("Total de datos a renderizar: %d", num_frames)

set output archivo_entrada."_plot.png"

# 3. Configuración del motor de renderizado a PNG
set terminal pngcairo size 600,600 background "#ffffff" enhanced


# 4. Estética
set size square
set xlabel "Tiempo"
set ylabel "Posición"

set xrange [0:15]

set style line 1 lc rgb '#1f77b4' pt 7 ps 1.5

set style line 2 lc rgb '#d91f1f' pt 7 ps 1.5

set style line 3 lc rgb '#21b41f' pt 7 ps 1.5


# 5. Bucle de generación de imágenes
do for [a = 0 : (num_frames - 1)] {
    # Guardamos en la ruta recibida por bash
    set output sprintf("%sframe_%04d.png", dir_frames, a)

    plot archivo_entrada u 1:2 index 0:a with points ls 1 t "Kinetica"  , \
         archivo_entrada u 1:3 index 0:a with points ls 2 t "Potencial" , \
         archivo_entrada u 1:4 index 0:a with points ls 3 t "Total"

}

# Cierra el último archivo de salida correctamente
set output

print "¡Frames renderizados desde Gnuplot!"