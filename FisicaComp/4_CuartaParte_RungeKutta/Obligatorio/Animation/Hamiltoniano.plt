x_label = "t "
y_label = "Energía"


stats archivo_entrada using 1:2 nooutput

# 2. Configuración sin generar archivos intermedios en disco
set terminal pngcairo size 800,600 background "#ffffff" enhanced font "Sans,12"

set xlabel x_label
set ylabel y_label
set grid

# 3. Rangos dinámicos
#set xrange [-STATS_max_x : STATS_max_x]
#set yrange [-STATS_max_y*1.3 : STATS_max_y * 1.3]

num_frames = STATS_blocks - 1

# 4. Tubería directa (pipe) a FFmpeg
# FFmpeg lee imágenes de la entrada estándar (-) y crea el MP4 directamente
set output video_out


# 5. Bucle de dibujo

plot archivo_entrada using 1:2 with points title "Hamiltoniano",\
archivo_entrada   using 1:3 with points title "Energía"


# 6. Cerrar el pipe
set output
print "¡Vídeo renderizado directamente sin PNG temporales!"