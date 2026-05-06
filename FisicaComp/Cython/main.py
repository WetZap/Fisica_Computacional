# Archivo: main.py
import time
# Importamos la función desde el archivo binario que acabamos de compilar
from montecarlo import calcular_pi_cython

N = 10_000_000

print(f"Calculando Pi con {N} iteraciones en Cython...")

start = time.time()
pi = calcular_pi_cython(N)
end = time.time()

print(f"Valor estimado de Pi: {pi}")
print(f"Tiempo de ejecución: {end - start:.4f} segundos")
