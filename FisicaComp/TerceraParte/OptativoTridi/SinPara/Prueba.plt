# 1. Configuración de entrada / salida
archivo_entrada = "Data/Auto/Phi_Prob_2D_Slice.bin"
video_out = "animacion_probabilidad_3D.mp4"

# 2. Configuración del terminal y gráfico
set terminal pngcairo size 800,600 background "#ffffff" enhanced font "Sans,12"

set title "Evolución de la Densidad de Probabilidad (Corte Z = 0.9L)" font "Sans,14"
set xlabel "Eje X"
set ylabel "Eje Y"
set zlabel "Probabilidad |{/Symbol y}|^2"

set grid
set hidden3d                  
set view 60, 30, 1.0, 1.0     
set pm3d                      
set palette defined (0 "blue", 1 "green", 2 "yellow", 3 "red") 

# Rangos espaciales de la caja (0 a 1)
set xrange [0 : 1]
set yrange [0 : 1]
set zrange [0 : 50.0]     

# 3. Definición manual de fotogramas (¡Sustituye al STATS!)
num_frames = 1999

# 4. Tubería directa a FFmpeg
comando_ffmpeg = sprintf("| ffmpeg -y -f image2pipe -vcodec png -framerate 20 -i - -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p %s", video_out)
set output comando_ffmpeg

# 5. Bucle de dibujo para datos binarios
do for [a=0 : num_frames] {
    # Matemáticas de lectura binaria:
    # 99 puntos en X * 99 puntos en Y * 8 bytes (real*8) = 78408 bytes por frame.
    # El origen espacial es (0.01, 0.01) y el espaciado dx=0.01, dy=0.01
    
    splot archivo_entrada binary array=(99,99) format="%double" skip=(a*78408) \
          dx=0.01 dy=0.01 origin=(0.01, 0.01, 0) \
          with pm3d title sprintf("Frame %d", a)
}

set output
print "¡Vídeo renderizado exitosamente desde matriz binaria!"