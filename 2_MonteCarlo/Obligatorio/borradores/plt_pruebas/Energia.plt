archivo_T = "/Datos/Temperaturas.dat"
archivo_M = "/Datos/Magnetizaciones.dat"

set terminal pngcairo size 800,600 enhanced font 'Verdana,10'
set output "Temperatura_vs_Magnetizacion2.png"

set xlabel "Temperatura"
set ylabel "Magnetización"

set style line 1 lc rgb '#1f77b4' pt 7 ps 1.5

#set yrange[-1.2:1.2]
#set xrange[0:5.2]

plot "<paste Datos/Temperaturas.dat Datos/Magnetizaciones.dat" using 1:2  with points ls 1 title "Datos"








