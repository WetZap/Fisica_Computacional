#!/bin/bash

DIR_DATOS="$HOME/Documentos/GitHub/Universidad/FisicaComp/PrimeraParte(Verlet)/EjercicioEntregable/4-/Datos"
DIR_GIFS="$HOME/Documentos/GitHub/Universidad/FisicaComp/PrimeraParte(Verlet)/EjercicioEntregable/4-/Gifs"


mkdir -p "$DIR_GIFS"

cd "$DIR_DATOS" || exit

for archivo in datos*.dat; do
    
    salida="$DIR_GIFS/Espacioxy${archivo%.*}.gif"
    salida_fase="$DIR_GIFS/Espaciofase${archivo%.*}.gif"
    
    echo "Procesando: $archivo -> $salida"
    

    gnuplot -e "archivo_entrada='$archivo'; archivo_salida='$salida'" ../animacionxy.plt


done

echo "¡Proceso terminado!"
