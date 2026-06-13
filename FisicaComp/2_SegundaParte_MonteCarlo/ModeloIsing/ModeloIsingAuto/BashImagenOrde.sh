#!/bin/bash

# Rutas relativas y absolutas
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Data/DatosOrde"

# Graficamos Temperatura vs Magnetización
echo "Generando gráfico de Temperatura vs Magnetización"



# Juntamos los archivos de Temperaturas y Magnetizaciones para graficar
paste "$DIR/Data/DatosOrde/Temperaturas.dat" "$DIR/Data/DatosOrde/Magnetizaciones.dat" > "$DIR/Data/DatosOrde/Temp_vs_Mag.dat"

gnuplot -e "archivo_entrada='$DIR/Data/DatosOrde/Temp_vs_Mag.dat'; archivo_salida='$DIR/Images/Orde/TempvsMag.png'" "$DIR/Animation/MagnetizacionOrde.plt"

gnuplot -e "archivo_entrada='$DIR/Data/DatosOrde/Temp_vs_Mag.dat'; archivo_salida='$DIR/Images/Orde/TempvsMag2.png'" "$DIR/Animation/MagnetizacionOrde2.plt"



echo "Generando gráfico de Temperatura vs Energía"
paste "$DIR/Data/DatosOrde/Temperaturas.dat" "$DIR/Data/DatosOrde/Energia.dat" > "$DIR/Data/DatosOrde/Temp_vs_Energia.dat"

gnuplot -e "archivo_entrada='$DIR/Data/DatosOrde/Temp_vs_Energia.dat';archivo_salida='$DIR/Images/Orde/TempvsEnergia.png'" "$DIR/Animation/Energia.plt"