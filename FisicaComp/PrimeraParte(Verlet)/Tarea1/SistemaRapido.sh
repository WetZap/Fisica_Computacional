#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Datos/DatosOut"
DIR_DATOS_TIERRA="$DIR/Datos/Tierra"
DIR_GIFS_SISTEMA="$DIR/Gifs"

# Directorios temporales para los frames (idealmente en RAM si tienes memoria de sobra, usando /dev/shm/)
mkdir -p "$DIR_GIFS_SISTEMA/tmp_NL" "$DIR_GIFS_SISTEMA/tmp_NLR" "$DIR_GIFS_SISTEMA/tmp_L" "$DIR_GIFS_SISTEMA/tmp_LR" "$DIR_GIFS_SISTEMA/tmp_T" "$DIR_GIFS_SISTEMA/tmp_TR"

cd "$DIR_DATOS_OUT" || exit

archivo_entrada_Sist=($(ls datos*.dat))
archivo_entrada_Sist_L=("${archivo_entrada_Sist[@]}" "Luna.dat")

archivos_string_sist="${archivo_entrada_Sist[*]}"    
archivos_string_sist_L="${archivo_entrada_Sist_L[*]}"

echo "Generando frames en paralelo ..."

# Lanzamos todos los procesos de Gnuplot al mismo tiempo con '&'
gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_NL/'; archivo_entrada='$archivos_string_sist'" ../../Animation/Sistema_NL.plt 2>/dev/null &
gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_NLR/'; archivo_entrada='$archivos_string_sist'" ../../Animation/Sistema_NLR.plt 2>/dev/null &
gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_L/'; archivo_entrada='$archivos_string_sist_L'" ../../Animation/Sistema_L.plt 2>/dev/null &
gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_LR/'; archivo_entrada='$archivos_string_sist_L'" ../../Animation/Sistema_LR.plt 2>/dev/null &

cd "$DIR_DATOS_TIERRA" || exit
archivo_entrada_Tierra=($(ls datos*.dat))
archivos_string_tierra="${archivo_entrada_Tierra[*]}"

gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_T/'; archivo_entrada='$archivos_string_tierra'" ../../Animation/Tierra.plt 2>/dev/null &
gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_TR/'; archivo_entrada='$archivos_string_tierra'" ../../Animation/TierraR.plt 2>/dev/null &

# Esperamos a que todos los Gnuplot terminen
wait
echo "Frames generados. Ensamblando GIFs con FFmpeg..."

# Función para compilar GIF rápidamente con paleta optimizada
crear_gif() {
    local dir_in=$1
    local out_file=$2
    # -framerate 50 equivale a tu delay 2 (100/2 = 50 fps). Si lo quieres más lento, baja este valor (ej: 30)
    ffmpeg -y -framerate 50 -i "$dir_in/frame_%04d.png" \
           -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
           -loop 0 "$out_file" -loglevel error
}

# Ensamblamos los GIFs (también se puede paralelizar)
crear_gif "$DIR_GIFS_SISTEMA/tmp_NL" "$DIR_GIFS_SISTEMA/SistemaNL.gif" &
crear_gif "$DIR_GIFS_SISTEMA/tmp_NLR" "$DIR_GIFS_SISTEMA/SistemaRastroNL.gif" &
crear_gif "$DIR_GIFS_SISTEMA/tmp_L" "$DIR_GIFS_SISTEMA/SistemaL.gif" &
crear_gif "$DIR_GIFS_SISTEMA/tmp_LR" "$DIR_GIFS_SISTEMA/SistemaRastroL.gif" &
crear_gif "$DIR_GIFS_SISTEMA/tmp_T" "$DIR_GIFS_SISTEMA/Tierra.gif" &
crear_gif "$DIR_GIFS_SISTEMA/tmp_TR" "$DIR_GIFS_SISTEMA/TierraR.gif" &

wait

# Limpieza de temporales
rm -rf "$DIR_GIFS_SISTEMA"/tmp_*

echo "¡Proceso terminado y optimizado!"
