# 1. Primero calculas las variables y estadísticas que necesitas
stats word(archivo_entrada, 1) nooutput
num_frames = STATS_blocks

set terminal gif animate delay 2 loop 0 size 800,800
set output archivo_salida


max_num_frames = 2000

set xlabel "x"
set ylabel "y"

set xrange [-1.5:1.5]
set yrange [-1.5:1.5]


set title "Simulación del sistema solar"

array Nombres[11] = ["Pluton","Sol","Mercurio", "Venus", "Tierra", "Marte", "Júpiter", "Saturno", "Urano", "Neptuno", "Luna"]


do for [a=0:(max_num_frames-1)] {
    plot for [i=1:words(archivo_entrada)] \
         word(archivo_entrada, i) index 0:a using 2:3 \
         title Nombres[i] with points pointtype 7 pointsize 1.5
}