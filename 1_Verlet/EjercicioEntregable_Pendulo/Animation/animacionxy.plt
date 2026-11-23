# 1. Primero calculas las variables y estadísticas que necesitas
stats archivo_entrada nooutput
num_frames = STATS_blocks

# 2. Después inicializas el motor gráfico SIN la palabra 'optimize'
set terminal gif animate loop 0 size 600,600
set output archivo_salida


set xlabel "x"
set ylabel "y"

# Bucle para dibujar cada fotograma
do for [a=0:(num_frames-1)]{
    set xrange[-1.5:1.5]
    set yrange[-1.5:1.5]
    plot archivo_entrada i a u (0):(0):5:6 w vectors nohead lw 2 lc rgb "black" t '', \
         archivo_entrada i a u 5:6 t 'Pendulo' w points pt 7
}
