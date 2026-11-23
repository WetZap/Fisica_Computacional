#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Data/Datos"
mkdir -p "$DIR/Images/ConInter"

# Graficamos Temperatura vs Magnetización
echo "Generando gráfico de Temperatura vs Magnetización"



# Juntamos los archivos de Temperaturas y Magnetizaciones para graficar
paste "$DIR/Data/Datos/Temperaturas.dat" "$DIR/Data/Datos/Magnetizaciones.dat" > "$DIR/Data/Datos/Temp_vs_Mag.dat"

gnuplot -e "archivo_entrada='$DIR/Data/Datos/Temp_vs_Mag.dat'; archivo_salida='$DIR/Images/ConInter/TempvsMag.png'" "$DIR/Animation/Magnetizacion.plt"




echo "Generando gráfico de Temperatura vs Energía"
paste "$DIR/Data/Datos/Temperaturas.dat" "$DIR/Data/Datos/Energia.dat" > "$DIR/Data/Datos/Temp_vs_Energia.dat"

gnuplot -e "archivo_entrada='$DIR/Data/Datos/Temp_vs_Energia.dat';archivo_salida='$DIR/Images/ConInter/TempvsEnergia.png'" "$DIR/Animation/Energia.plt"