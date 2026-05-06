#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Datos/"
DIR_GIFS_SISTEMA="$DIR/Video" # Asegúrate de que este directorio base exista
DIR_TMP="$DIR_GIFS_SISTEMA/tmp_frames"


cd "$DIR_DATOS_OUT" || exit

# Leer todos los archivos de datos y temperaturas en arrays
archivos=($(ls -v datos*.dat))
archivos_energia=($(ls -v energia*.dat))

echo "Se van a procesar ${#archivos[@]} archivos."
rm -rf "$DIR_GIFS_SISTEMA/Imagen" # Limpiamos la carpeta de imágenes por seguridad
mkdir -p "$DIR_GIFS_SISTEMA/Imagen" # Creamos la carpeta de imágenes si no existe



for i in "${!archivos[@]}"; do
    archivo="${archivos[$i]}"
    archivo_energia="${archivos_energia[$i]}"
    archivo_salida="$DIR_GIFS_SISTEMA/Imagen/Arch_${archivo%.dat}.png"
    echo "Generando imágenes en Gnuplot..."
    
    # Vaciar temporal por seguridad en cada nueva temperatura


    # Ejecutamos gnuplot pasándole las variables desde Bash de forma limpia
    gnuplot -e "archivo_salida='$archivo_salida'; archivo_entrada='$archivo_energia'" "$DIR/Animation/AnimacionRap.plt" > /dev/null 2>&1


done

# Limpieza final

echo "====================================="
echo "¡Proceso finalizado con éxito!"






