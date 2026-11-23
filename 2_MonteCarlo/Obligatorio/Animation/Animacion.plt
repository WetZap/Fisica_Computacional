# 1. Definimos variables por defecto (por si abres el script a mano sin Bash)
if (!exists("dir_frames")) dir_frames = "frames/"
if (!exists("archivo_entrada")) archivo_entrada = "matrices_50x50.txt"
if (!exists("temperatura")) temperatura = 0.0

# 2. Analizamos el archivo formateado
stats archivo_entrada nooutput
num_frames = STATS_blocks
print sprintf("Total de matrices a renderizar: %d", num_frames)

# 3. Configuración del motor de renderizado a PNG
set terminal pngcairo size 600,600 background "#ffffff" enhanced

# 4. Estética de la matriz
set size square
set xlabel "Columna (x)"
set ylabel "Fila (y)"

# Invertimos el eje Y para que la coordenada (0,0) quede arriba a la izquierda
set yrange [] reverse
set autoscale xfix

# Fijamos los límites de la paleta según tus datos (-1 y 1)
set cbrange [-1:1]   
set palette rgbformulae 22,13,-31

# 5. Bucle de generación de imágenes
do for [a = 0 : 500 - 1] {
    # Guardamos en la ruta recibida por bash
    set output sprintf("%sframe_%04d.png", dir_frames, a)
    
    # Añadimos la Temperatura T al título dinámicamente
    set title sprintf("Evolución temporal - Paso: %d (T = %g)", a, temperatura)
    
    plot archivo_entrada index a matrix with image
}

print "¡Frames renderizados desde Gnuplot!"