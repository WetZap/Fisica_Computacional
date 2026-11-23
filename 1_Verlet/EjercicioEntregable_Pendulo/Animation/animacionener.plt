# 1. Primero calculas las variables y estadísticas que necesitas
stats archivo_entrada nooutput
num_frames = STATS_blocks

# 2. Después inicializas el motor gráfico SIN la palabra 'optimize'
set terminal gif animate loop 0 size 600,600
set output archivo_salida

set xra[0:10]
set yra[0:20/escala]


set xlabel "t"
set ylabel "E"


do for[a = 0:100]{
    plot archivo_entrada i 0:a u 1:2 t 'Cinética' w line , \
         archivo_entrada i 0:a u 1:3 t 'Potencial' w line , \
         archivo_entrada i 0:a u 1:4 t 'Total' w line 

}