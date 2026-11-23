#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Data/Datos"
DIR_GIFS_SISTEMA="$DIR/Video/Video" # Asegúrate de que este directorio base exista
DIR_TMP="$DIR_GIFS_SISTEMA/tmp_frames"

mkdir -p "$DIR_TMP"
cd "$DIR_DATOS_OUT" || exit

# Leer todos los archivos de datos en un array
archivos=($(ls -v datos*.dat))
temperaturas=($(cat Temperaturas.dat))

echo "Se van a procesar ${#archivos[@]} archivos."

for i in "${!archivos[@]}"; do
    archivo="${archivos[$i]}"
    T="${temperaturas[$i]}"
    N="$temperaturas[1]" # Asumimos que el nombre del archivo tiene la temperatura como parte de su nombre, ajusta esto si no es así


    echo "====================================="
    echo "Procesando $archivo..."
    
    # Calcular el número de frames (150 * 150 * 4 bytes por entero = 90,000 bytes por frame)
    size=$(stat -c%s "$archivo")
    num_frames=$((size / (N * N * 4)))
    echo "Frames detectados matemáticamente: $num_frames"

    echo "Generando imágenes en Gnuplot..."
    # Vaciar temporal por seguridad
    rm -f "$DIR_TMP"/*.png

    # Ejecutamos gnuplot pasándole el archivo binario DIRECTAMENTE y el num_frames
    gnuplot -e "dir_frames='$DIR_TMP/'; archivo_entrada='$archivo'; num_frames=$num_frames;N = $N; temperatura=$T;" "$DIR/Animation/Animacion.plt"

    video_out="$DIR_GIFS_SISTEMA/simulacion_${archivo%.dat}.mp4"
    echo "Ensamblando vídeo con FFmpeg: $video_out"
    
    # Renderizamos este archivo
    ffmpeg -y -framerate 20 -i "$DIR_TMP/frame_%04d.png" -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 "$video_out"

done

# Limpieza final
rm -rf "$DIR_TMP"
echo "====================================="
echo "¡Proceso finalizado con éxito!"