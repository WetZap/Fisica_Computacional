# Configuración del terminal para exportar una imagen PNG de alta calidad
set terminal pngcairo size 800,600 enhanced font 'Arial,12'
set output archivo_salida

# Título y etiquetas de los ejes
set title "Magnetización promedio y Energía por espín vs Temperatura (Caso sin interacciones)" font ",14"
set xlabel "Temperatura (T)"
set ylabel "Magnetización por espín (m) y Energía por espín (u)"

# Mostrar una cuadrícula de fondo para facilitar la lectura
set grid ytics xtics lc rgb '#e0e0e0' lw 1 lt 0

# Rango de los ejes (ajustado para T entre 0 y 5, y energía entre -1 y 0)
set xrange [0:5.5]
set yrange [-1.1:1.1]

# Definición de la función teórica u = tanh(J/T) con J = 1
m_teorico(x) = tanh(1.0 / x)

# Definición de la función teórica u = -tanh(J/T) con J = 1
u_teorico(x) = -tanh(1.0 / x)

# Personalización de estilos visuales

set style line 1 lc rgb '#1f77b4' pt 7 ps 1.5
set style line 2 lc rgb '#d62728' lw 2.5

set style line 3 lc rgb '#1100ff' pt 7 ps 1.5
set style line 4 lc rgb '#bc27d6' lw 2.5

# Comando principal de dibujo
plot archivo_entrada_1 using 1:2 with points ls 1 title 'Simulación Monte Carlo', \
     m_teorico(x) with lines ls 2 title 'Curva Teórica: tanh(1/T)', \
    archivo_entrada_2 using 1:2 with points ls 3 title 'Simulación Monte Carlo', \
     u_teorico(x) with lines ls 4 title 'Curva Teórica: -tanh(1/T)'

# Imprimir mensaje en la terminal al terminar
print "Gráfica generada exitosamente como 'magnetizacion_energia_vs_temperatura.png'"

