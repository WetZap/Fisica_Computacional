# 1. Configurar terminal para generar múltiples PNGs
set terminal pngcairo size 600,600 background rgb 'white'

# 2. Configurar el estilo del gráfico
set size square           # Mantener proporciones cuadradas
set xrange [0:22]         # Tamaño de tu caja L=22
set yrange [0:22]
set xlabel "x"
set ylabel "y"
unset key                 # Quitar la leyenda
set grid                  # Mostrar cuadrícula de fondo

# 3. Contar el número de bloques (frames)
# Gnuplot puede contar automáticamente los bloques separados por 2 líneas en blanco
stats archivo_entrada nooutput
nframes = STATS_blocks

print sprintf("Se encontraron %d frames en el archivo.", nframes)

# 4. Bucle para generar cada frame del MP4
do for [i=0:nframes-1] {
    
    # Establecer la ruta de salida para este frame específico
    set output sprintf("%sframe_%04d.png", dir_frames, i)
    set title sprintf("Dinámica molecular de Lennard-Jones - Frame %d", i)
    
    # Dibujar usando puntos azules (index lee los bloques separados por 2 líneas vacías)
    plot archivo_entrada index i using 2:3 with points pt 7 ps 1.5 lc rgb 'blue'
}

print "¡Frames generados con éxito para FFmpeg!"