# 1. Primero calculas las variables y estadísticas que necesitas
stats archivo_entrada nooutput
num_frames = STATS_blocks

# 2. Después inicializas el motor gráfico SIN la palabra 'optimize'
set terminal png size 600,600
set output archivo_salida

# 3. Aquí ya iría tu bucle 'do for' con los comandos de plot



set xlabel "θ"
set ylabel "T/T0"
set xrange[0:4]
set yrange[0:3.6]

# Bucle para dibujar cada fotograma
plot archivo_entrada  t 'Periodo' w linespoints pt 7
