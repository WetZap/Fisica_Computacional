
# Archivo: montecarlo.pyx

# Equivalente en C a: #include <stdlib.h>
from libc.stdlib cimport rand, RAND_MAX

# cpdef crea una función rápida en C y, a la vez, 
# la hace accesible desde tus scripts en Python
cpdef double calcular_pi_cython(long n):
    cdef int i
    cdef int acc = 0
    cdef double x, y
    cdef double escala = 1.0 / RAND_MAX

    for i in range(n):
        # Usamos rand() directamente de C, que es ultrarrápido
        x = rand() * escala
        y = rand() * escala
        
        if (x*x + y*y) < 1.0:
            acc += 1

    return 4.0 * acc / n
