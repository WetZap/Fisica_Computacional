#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Datos/"
DIR_GIFS_SISTEMA="$DIR/Video" # Asegúrate de que este directorio base exista
DIR_TMP="$DIR_GIFS_SISTEMA/tmp_frames"



mkdir -p "$DIR_TMP"
cd "$DIR_DATOS_OUT" || exit

# Leer todos los archivos de datos y temperaturas en arrays
archivos=($(ls -v datos*.dat))
archivos_energia=($(ls -v energia*.dat))

echo "Se van a procesar ${#archivos[@]} archivos."

for i in "${!archivos[@]}"; do
    archivo="${archivos[$i]}"
    archivo_energia="${archivos_energia[$i]}"
    echo "Generando imágenes en Gnuplot..."
    
    # Vaciar temporal por seguridad en cada nueva temperatura
    rm -f "$DIR_TMP"/*.png

    # Ejecutamos gnuplot pasándole las variables desde Bash de forma limpia
    gnuplot -e "dir_frames='$DIR_TMP/'; archivo_entrada='$archivo'" "$DIR/Animation/Posicion.plt"

    video_out="$DIR_GIFS_SISTEMA/simulacion_${archivo%.dat}_T${T}.mp4"
    echo "Ensamblando vídeo con FFmpeg: $video_out"
    
    # Renderizamos este archivo concreto antes de pasar al siguiente
    ffmpeg -y -framerate 20 -i "$DIR_TMP/frame_%04d.png" -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 "$video_out"


done

# Limpieza final
rm -rf "$DIR_TMP"
echo "====================================="
echo "¡Proceso finalizado con éxito!"






