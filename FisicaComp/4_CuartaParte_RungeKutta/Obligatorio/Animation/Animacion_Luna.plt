x_label = "Posición X "
y_label = "Posición Y "


stats archivo_entrada_Luna using 1:2 nooutput

# 2. Configuración sin generar archivos intermedios en disco
set terminal pngcairo size 800,600 background "#ffffff" enhanced font "Sans,12"

set xlabel x_label
set ylabel y_label
set grid

# 3. Rangos dinámicos
set xrange [STATS_min_x : STATS_max_x]
set yrange [STATS_min_y : STATS_max_y * 1.3]

num_frames = STATS_blocks - 1

# 4. Tubería directa (pipe) a FFmpeg
# FFmpeg lee imágenes de la entrada estándar (-) y crea el MP4 directamente
comando_ffmpeg = sprintf("| ffmpeg -y -f image2pipe -vcodec png -framerate 20 -i - -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p %s", video_out)
set output comando_ffmpeg


# 5. Bucle de dibujo
do for [a=0:300] {
    plot archivo_entrada index 0:a using 1:2 with points title sprintf("Frame %d", a),\
         archivo_entrada_Luna index 0:a using 1:2 with points pointtype 7 pointsize 1.5 linecolor rgb "red" title "Luna"
}

# 6. Cerrar el pipe
set output
print "¡Vídeo renderizado directamente sin PNG temporales!"