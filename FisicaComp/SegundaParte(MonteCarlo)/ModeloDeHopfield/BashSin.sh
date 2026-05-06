#!/bin/bash
START=$(date +%s)

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Data/DatosSin"
DIR_GIFS_SISTEMA="$DIR/Video/VideoS" # Asegúrate de que este directorio base exista
DIR_TMP="$DIR_GIFS_SISTEMA/tmp_frames"
DIR_SCRIPT="$DIR/Scripts/Modelo_Sin_Interaccion.f90"
DIR_EJECUTABLE="$DIR/Scripts/ModeloSin.out"


gfortran -O3  "$DIR_SCRIPT" -o "$DIR_EJECUTABLE"

if [ $? -eq 0 ]; then
    echo "Compilación exitosa. Ejecutando..."
    "$DIR_EJECUTABLE"
else
    echo "Error en la compilación."
fi



mkdir -p "$DIR_TMP"
cd "$DIR_DATOS_OUT" || exit

archivos=($(ls -v datos*.dat))
temperaturas=($(cat Temperaturas.dat))



echo "Se van a procesar ${#archivos[@]} archivos."

for i in "${!archivos[@]}"; do
    archivo="${archivos[$i]}"
    T="${temperaturas[$i]}"
    archivo_matriz="Matrices/${archivo%.dat}_50x50.txt"

    echo "====================================="
    echo "Procesando $archivo (Temperatura T=$T)..."
    
    # 1. AWK: Convertir cada línea de 2500 columnas en bloques de 50x50.
    # Se usa el archivo de la iteración ($archivo), NO Resultados.txt.
    awk -v N=50 '
    NF == 2500 {
        for(i=1; i<=N; i++) {
            for(j=1; j<=N; j++) {
                printf "%s ", $(j + (i-1)*N)
            }
            print "" # Salto de línea de fila
        }
        print "\n" # Doble salto de línea separador de bloques (frames)
    }' "$archivo" > "$archivo_matriz"

    echo "Generando imágenes en Gnuplot..."
    
    # Vaciar temporal por seguridad en cada nueva temperatura
    rm -f "$DIR_TMP"/*.png

    # Ejecutamos gnuplot pasándole las variables desde Bash de forma limpia
    gnuplot -e "dir_frames='$DIR_TMP/'; archivo_entrada='$archivo_matriz'; temperatura=$T" "$DIR/Animation/Animacion.plt"

    video_out="$DIR_GIFS_SISTEMA/simulacion_${archivo%.dat}_T${T}.mp4"
    echo "Ensamblando vídeo con FFmpeg: $video_out"
    
    # Renderizamos este archivo concreto antes de pasar al siguiente
    ffmpeg -y -framerate 20 -i "$DIR_TMP/frame_%04d.png" -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 "$video_out"

    #Borrar el archivo matricial gigante si quieres ahorrar espacio de disco
     rm "$archivo_matriz"
done

bash "$DIR/BashImagenSin.sh"
# Limpieza final
rm -rf "$DIR_TMP"
echo "====================================="
echo "¡Proceso finalizado con éxito!"
echo "====================================="

sleep 2
END=$(date +%s)
DIFF=$(( $END - $START ))
resultado=$(echo "scale=3; $DIFF / 60" | bc)

echo "El script tardó $resultado minutos."