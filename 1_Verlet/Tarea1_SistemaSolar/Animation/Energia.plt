set terminal pngcairo size 800,600 enhanced font 'Verdana,10'

set output archivo_salida

#set xra[0:2]
#set yra[-0.0003:0.0003]


set size square 


    plot archivo_entrada  u 1:2 t"Kinética", \
            archivo_entrada  u 1:3 t"Potencial", \
            archivo_entrada  u 1:4 t"Total"

    