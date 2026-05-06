# 1. Variables y configuración base
stats word(archivo_entrada, 1) nooutput
num_frames = STATS_blocks

# Usar pngcairo para máxima calidad y velocidad
set terminal pngcairo size 800,800 enhanced font 'Verdana,10'
max_num_frames = 2000
paso_frames = 10 # Salta de 10 en 10 para acelerar la simulación sin crear demasiados archivos

set xlabel "x"
set ylabel "y"
set xrange [-1.5:1.5]
set yrange [-1.5:1.5]
set title "Simulación del sistema solar"

array Nombres[10] = ["Pluton","Sol","Mercurio", "Venus", "Tierra", "Marte", "Júpiter", "Saturno", "Urano", "Neptuno"]

# Bucle generando PNGs individuales
do for [a=0:(max_num_frames-1):paso_frames] {
    # El archivo de salida cambia en cada iteración (ej: frame_0000.png)
    set output sprintf("%sframe_%04d.png", dir_frames, a/paso_frames)
    
    plot for [i=1:words(archivo_entrada)] \
         word(archivo_entrada, i) index a using 2:3 \
         title Nombres[i] with points pointtype 7 pointsize 1.5
}
