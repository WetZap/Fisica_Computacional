#!/bin/bash

# Rutas relativas a la carpeta de este script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS="$DIR/Datos"
DIR_DATOS_ENERGIA="$DIR/Datos/Energias"
DIR_GIFS="$DIR/Gifs"
DIR_PLT="$DIR/Animation"


escala_fase=(0.5 1 2 3 4 5 6 7 8 9 10 11 12) # Ajusta este valor según tus necesidades
escala_ener=(1 10 10 2 1 1 1 1 1 1 1 1 1 ) # Ajusta este valor según tus necesidades
j_bash=0

mkdir -p "$DIR_GIFS/Espacio" "$DIR_GIFS/Fase" "$DIR_GIFS/Energia" "$DIR_GIFS/Periodo"

cd "$DIR_DATOS" || exit


for archivo in datos*.dat; do

    salida="$DIR_GIFS/Espacio/Espacioxy${archivo%.*}.gif"
    salida_fase="$DIR_GIFS/Fase/Espaciofase${archivo%.*}.gif"


    echo "Procesando: $archivo -> $salida"


    gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida'" "$DIR_PLT/animacionxy.plt"

    gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida_fase'; escala=${escala_fase[$j_bash]}" "$DIR_PLT/animacionfase.plt"
    j_bash=$((j_bash + 1))
done

cd "$DIR_DATOS_ENERGIA" || exit

j_bash=0

for archivo in datos*.dat; do

    salida_energia="$DIR_GIFS/Energia/Espacioenergia${archivo%.*}.gif"

    echo "Procesando: $archivo -> $salida_energia"

    gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida_energia';escala = ${escala_ener[$j_bash]}" "$DIR_PLT/animacionener.plt"
    j_bash=$((j_bash + 1))
done

cd "$DIR_DATOS" || exit

salida_periodo="$DIR_GIFS/Periodo/Periodo.png"

archivo="$DIR/PeriodosAjuste.dat"

gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida_periodo'" "$DIR_PLT/animacionperio.plt"

echo "¡Proceso terminado!"
