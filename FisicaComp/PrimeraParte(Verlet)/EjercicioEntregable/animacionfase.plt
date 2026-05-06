# 1. Primero calculas las variables y estadísticas que necesitas
stats archivo_entrada nooutput
num_frames = STATS_blocks

# 2. Después inicializas el motor gráfico SIN la palabra 'optimize'
set terminal gif animate loop 0 size 600,600
set output archivo_salida

# 3. Aquí ya iría tu bucle 'do for' con los comandos de plot



set xlabel "θ"
set ylabel "θ̇"


cadena = system("awk 'NR==1 {print $2}' " . archivo_entrada)
dato = cadena + 0  

cadena = system("awk 'NR==1 {print $3}' " . archivo_entrada)
dato1 = cadena + 0  

pi = atan(1.0)*4.0
g = 9.8
l = 1.0
m = 1.0
theta_punto = dato1
theta = dato


b = sqrt(m*g*l)
a = sqrt((1/2)*m*l**2)

Et = (0.5)*m* l**2 * (theta_punto)**2 + m*g*l*(1.0-cos(theta))


y(x) = +sqrt(abs((Et/((1.0/2.0)*m*l**2))-g*((1-cos(x))/((0.5)*l))))
u(x) = -sqrt(abs((Et/((1.0/2.0)*m*l**2))-g*((1-cos(x))/((0.5)*l))))


set xlabel 'θ'
set ylabel 'θ̇'

# Bucle para dibujar cada fotograma
do for [a=0:(num_frames-1)]{
    set xrange[-3*escala:3*escala]
    set yrange[-3*escala:3*escala]
    plot archivo_entrada i 0:a u 2:3 t 'Curva Simulada' w points pt 7, \
          archivo_entrada u 2:(y($2)) t 'Curva Teórica' w lines, \
          archivo_entrada u 2:(u($2)) t '' w lines ,
} 


# Suponiendo que el valor está en la fila 1, columna 2
