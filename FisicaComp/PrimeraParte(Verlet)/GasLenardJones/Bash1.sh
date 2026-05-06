#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Datos"
DIR_GIFS_SISTEMA="$DIR/Video"
DIR_TMP="$DIR_GIFS_SISTEMA/tmp_frames"

mkdir -p "$DIR_TMP"
mkdir -p "$DIR_GIFS_SISTEMA"

cd "$DIR_DATOS_OUT" || exit

# Leer todos los archivos de datos (suponiendo que son distintas simulaciones o temperaturas)
archivos=($(ls -v datos*.dat 2>/dev/null))

if [ ${#archivos[@]} -eq 0 ]; then
    echo "No se encontraron archivos datos*.dat en $DIR_DATOS_OUT"
    exit 1
fi

echo "Se van a procesar ${#archivos[@]} archivos."

for archivo in "${archivos[@]}"; do
    echo "Generando imágenes en Gnuplot para $archivo..."
    
    # Vaciar temporal por seguridad
    rm -f "$DIR_TMP"/*.png

    # Pasamos dir_frames y la ruta del archivo de entrada a Gnuplot
    gnuplot -e "dir_frames='$DIR_TMP/'; archivo_entrada='$DIR_DATOS_OUT/$archivo'" "$DIR/Animation/Posicion.plt"

    # Nombramos el vídeo final basándonos en el nombre del archivo de datos
    nombre_base="${archivo%.dat}"
    video_out="$DIR_GIFS_SISTEMA/simulacion_${nombre_base}.mp4"
    
    echo "Ensamblando vídeo con FFmpeg: $video_out"
    ffmpeg -y -framerate 20 -i "$DIR_TMP/frame_%04d.png" -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 "$video_out"

done

# Limpieza final
rm -rf "$DIR_TMP"
echo "====================================="
echo "¡Proceso finalizado con éxito!"