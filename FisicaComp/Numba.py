import time
import numpy as np
from numba import jit

N = 10_000_000_00 # Muchas iteraciones para ver la diferencia de tiempo

# 1. Versión en Python normal
def monte_carlo_pi_python(n):
    acc = 0
    for i in range(n):
        x = np.random.random()
        y = np.random.random()
        if (x**2 + y**2) < 1.0:
            acc += 1
    return 4.0 * acc / n

# 2. Versión acelerada con Numba
@jit(nopython=True)
def monte_carlo_pi_numba(n):
    acc = 0
    for i in range(n):
        x = np.random.random()
        y = np.random.random()
        if (x**2 + y**2) < 1.0:
            acc += 1
    return 4.0 * acc / n

# (Opcional) Llamar a numba una vez con un número pequeño 
# para que compile antes de medir el tiempo
_ = monte_carlo_pi_numba(10)


# Mide el tiempo de Numba
start = time.time()

print(monte_carlo_pi_numba(N))
print(f"Tiempo Numba: {time.time() - start:.4f} s")

# Mide el tiempo de Python
start = time.time()
print(monte_carlo_pi_python(N))
print(f"Tiempo Python: {time.time() - start:.4f} s")


