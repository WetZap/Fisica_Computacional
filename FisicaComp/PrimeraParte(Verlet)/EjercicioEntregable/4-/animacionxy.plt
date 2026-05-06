# 1. Primero calculas las variables y estadísticas que necesitas
stats archivo_entrada nooutput
num_frames = STATS_blocks

# 2. Después inicializas el motor gráfico SIN la palabra 'optimize'
set terminal gif animate loop 0 size 600,600
set output archivo_salida

# 3. Aquí ya iría tu bucle 'do for' con los comandos de plot


pi = atan(1.0)*4.0
g = 9.8
l = 1.0
m = 1.0

cadena = system("awk 'NR==1 {print $2}' " . archivo_entrada)
dato = cadena + 0  
print "El dato extraído es: ", dato


theta = dato
omega = sqrt(g/l)

y(x) = theta*cos(omega*x)

set xrange[0:6]
set yrange[-2:2]

set xlabel "x"
set ylabel "y"

# Bucle para dibujar cada fotograma
do for [a=0:(num_frames-1)]{

        plot archivo_entrada u 1:(y($1)) t 'Curva Teórica' w lines lt 1 , \
            archivo_entrada i 0:a u 1:2 t 'Pendulo' w linespoints pt 8
             
}
