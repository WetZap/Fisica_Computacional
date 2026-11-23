#!/bin/bash

# Rutas relativas a la carpeta de este script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS="$DIR/Datos"
DIR_GIFS="$DIR/Gifs"


mkdir -p "$DIR_GIFS"

cd "$DIR_DATOS" || exit

for archivo in datos*.dat; do

    salida="$DIR_GIFS/Espacioxy${archivo%.*}.gif"
    salida_fase="$DIR_GIFS/Espaciofase${archivo%.*}.gif"

    echo "Procesando: $archivo -> $salida"


    gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida'" "$DIR/Animation/animacionxy.plt"


done

echo "¡Proceso terminado!"
