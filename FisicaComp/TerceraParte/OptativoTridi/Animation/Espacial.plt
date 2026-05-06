# 1. Configuración de entrada / salida
video_out = "animacion_probabilidad_3D.mp4"

# 2. Configuración del terminal y gráfico
set terminal pngcairo size 800,600 background "#ffffff" enhanced font "Sans,12"

set title "Evolución de la Densidad de Probabilidad (Corte Z = L/2)" font "Sans,14"
set xlabel "Eje X"
set ylabel "Eje Y"
set zlabel "Probabilidad |{/Symbol y}|^2"

set grid
set hidden3d                  
set view 60, 30, 1.0, 1.0     
set pm3d                      
set palette defined (0 "blue", 1 "green", 2 "yellow", 3 "red") 

# 3. Rangos fijos (¡Así evitamos el error de STATS!)
# Tu caja de Fortran siempre va de 0 a 1 (Longitud = 1.0)
set xrange [0 : 1]
set yrange [0 : 1]

# Puedes subir el límite Z a 10.0 o 50.0 según lo concentrada que esté la onda inicial
set zrange [0 : 15.0]     
set cbrange [0 : 15.0]    

# Obtenemos SOLO el número de bloques que hay en el archivo
stats archivo_entrada using 1:2 nooutput
num_frames = STATS_blocks - 1

# 4. Tubería directa a FFmpeg
comando_ffmpeg = sprintf("| ffmpeg -y -f image2pipe -vcodec png -framerate 20 -i - -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p %s", video_out)
set output comando_ffmpeg

# 5. Bucle de dibujo
do for [a=0 : num_frames] {
    splot archivo_entrada index a using 1:2:3 with pm3d title sprintf("Frame %d", a)
}

set output
print "¡Vídeo renderizado exitosamente!"