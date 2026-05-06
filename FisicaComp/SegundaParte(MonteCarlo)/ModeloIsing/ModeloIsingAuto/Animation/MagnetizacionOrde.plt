# Configuración del terminal para exportar una imagen PNG de alta calidad
set terminal pngcairo size 800,600 enhanced font 'Arial,12'
set output archivo_salida

# Título y etiquetas de los ejes
set title "Magnetización promedio por espín vs Temperatura " font ",14"
set xlabel "Temperatura (T)"
set ylabel "Magnetización por espín (m)"

# Mostrar una cuadrícula de fondo para facilitar la lectura
set grid ytics xtics lc rgb '#e0e0e0' lw 1 lt 0

# Rango de los ejes (ajustado para T entre 0 y 5, y energía entre -1 y 0)
set xrange [0:3]
set yrange [-0.1:1.1]

# Definición de la función teórica u = tanh(J/T) con J = 1
m_teorico(x) = (x<2.269) ? (1.0- 1.0/(sinh(2.0/x)**4))**(1.0/8.0) : 0.0


# Personalización de estilos visuales
# lt 1: Puntos azules oscuros, tipo de punto 7 (círculos sólidos)
# lt 2: Línea roja sólida, grosor 2
set style line 1 lc rgb '#1f77b4' pt 7 ps 1.5
set style line 2 lc rgb '#d62728' lw 2.5

# Comando principal de dibujo
plot archivo_entrada using 1:2 with points ls 1 title 'Simulación Monte Carlo', \
     m_teorico(x) with lines ls 2 title 'Curva Teórica:  (1.0- 1.0/(sinh(2.0/x)**4))**(1.0/8.0)'

# Imprimir mensaje en la terminal al terminar
print "Gráfica generada exitosamente como 'magnetizacion_vs_temperatura.png'"





