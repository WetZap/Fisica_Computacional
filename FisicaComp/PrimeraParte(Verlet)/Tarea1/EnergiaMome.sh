#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DATOS_ENERGIA="$DIR/Datos/EnergiaMomento/Energia.dat"

DATOS_MOMENTO="$DIR/Datos/EnergiaMomento/Momento_angular.dat"

SALIDA_ENERGIA="$DIR/Gifs/Energia.png"
SALIDA_MOMENTO="$DIR/Gifs/Momento_angular.png"


echo "Generando gráficos de energía y momento angular ..."
gnuplot -e "archivo_entrada='$DATOS_ENERGIA'" -e "archivo_salida='$SALIDA_ENERGIA'" Animation/Energia.plt &
gnuplot -e "archivo_entrada='$DATOS_MOMENTO'" -e "archivo_salida='$SALIDA_MOMENTO'" Animation/MomentoAng.plt

echo "Gráficos generados: 'Energia.png' y 'Momento_angular.png'"