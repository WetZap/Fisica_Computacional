# 1. Definimos variables por defecto (por si abres el script a mano sin Bash)
if (!exists("dir_frames")) dir_frames = "frames/"
if (!exists("archivo_entrada")) archivo_entrada = "datos.dat"
if (!exists("num_frames")) num_frames = 500 # Ahora lo recibe de Bash

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

# Fijamos los límites de la paleta según tus datos
set cbrange [0:1]   
set palette rgbformulae 22,13,-31

# 5. Bucle de generación de imágenes leyendo binario
do for [a = 0 : num_frames - 1] {
    set output sprintf("%sframe_%04d.png", dir_frames, a)
    set title sprintf("Evolución temporal - Paso: %d (T = %g)", a, temperatura)

    # 'skip' hace que Gnuplot se salte los bytes de las iteraciones anteriores (a * 90000 bytes)
    # 'scan=yx' lee en formato columna-primero, tal cual lo escupe Fortran
    plot archivo_entrada binary array=150x150 format="%int" skip=(a*90000) scan=yx with  image
}

print "¡Frames renderizados desde Gnuplot!"