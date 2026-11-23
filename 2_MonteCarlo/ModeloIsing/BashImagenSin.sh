#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Data/DatosSin"
mkdir -p "$DIR/Images/SinInter"

# Graficamos Temperatura vs Magnetización
echo "Generando gráfico de Temperatura vs Magnetización"

gnuplot -e "archivo_entrada='$DIR/Data/DatosSin/MagnetizacionSin.dat'; archivo_salida='$DIR/Images/SinInter/TempvsMag.png'" "$DIR/Animation/MagnetizacionSin.plt"




echo "Generando gráfico de Temperatura vs Energía"

gnuplot -e "archivo_entrada='$DIR/Data/DatosSin/EnergiaSin.dat';archivo_salida='$DIR/Images/SinInter/TempvsEnergia.png'" "$DIR/Animation/EnergiaSin.plt"



gnuplot -e "archivo_entrada_1='$DIR/Data/DatosSin/MagnetizacionSin.dat'; archivo_entrada_2='$DIR/Data/DatosSin/EnergiaSin.dat'; archivo_salida='$DIR/Images/SinInter/MagneEnerSin.png'" "$DIR/Animation/MagneEnerSin.plt"