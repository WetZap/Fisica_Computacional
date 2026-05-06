import numpy as np
import matplotlib.pyplot as plt
import time

def resolver_laplace_forma_arbitraria():
    print("--- Programa Laplace (Gauss-Seidel) con Máscara Geométrica ---")
    # Valores por defecto para facilitar la ejecución rápida
    max_steps = int(input("Pasos de cuadrícula por unidad (ej. 30, a mayor número más resolución) -> ") or 30)
    acc = float(input("Precisión requerida por punto (ej. 0.0001) -> ") or 0.0001)

    N = 2 * max_steps + 1
    v = np.zeros((N, N))

    # 1. Crear cuadrícula espacial de -1 a 1
    x = np.linspace(-1, 1, N)
    y = np.linspace(-1, 1, N)
    X, Y = np.meshgrid(x, y, indexing='ij')

    # 2. Definir la forma matemáticamente mediante una máscara booleana
    mascara = np.zeros((N, N), dtype=bool)
    
    # --- ZONA DE GEOMETRÍA ---
    # Forma activa actual: Círculo (Cilindro) de radio 0.4
    #R = 0.4
    #mascara[X**2 + Y**2 <= R**2] = True
    #v[mascara] = 1.0  # Aplicar el potencial de 1V al objeto

    # (Ejemplo alternativo) Para usar un Condensador de placas paralelas, 
    # comenta las 3 líneas de arriba y descomenta las siguientes:
    mascara[(X >= -0.6) & (X <= -0.5) & (abs(Y) <= 0.6)] = True
    mascara[(X >= 0.5) & (X <= 0.6) & (abs(Y) <= 0.6)] = True
    v[(X >= -0.6) & (X <= -0.5) & (abs(Y) <= 0.6)] = 1.0   # Placa izquierda a 1V
    v[(X >= 0.5) & (X <= 0.6) & (abs(Y) <= 0.6)] = 2.0    # Placa derecha a -1V
     #-------------------------

    print("\nCalculando relajación... por favor espera.")
    diff = acc + 1.0
    iteraciones = 0
    t_inicio = time.time()

    # 3. Bucle principal de relajación (Gauss-Seidel)
    while iteraciones <= 10 or diff >= acc:
        diff = 0.0
        iteraciones += 1
        for i in range(1, N - 1):
            for j in range(1, N - 1):
                # Calcular el potencial SOLO si el punto NO pertenece al metal/máscara
                if not mascara[i, j]:
                    tmp = v[i, j]
                    # Promedio de los 4 vecinos
                    v[i, j] = (v[i-1, j] + v[i+1, j] + v[i, j-1] + v[i, j+1]) / 4.0
                    diff += abs(tmp - v[i, j])
                    
        diff /= (N * N)

    t_total = time.time() - t_inicio
    print(f"Número de iteraciones = {iteraciones}, Tiempo de CPU = {t_total:.2f} segundos")
    print(f"Precisión/pto: requerida = {acc}, actual = {diff:.6e}")

    # 4. Calcular el campo eléctrico E = -∇V
    ex = np.zeros((N, N))
    ey = np.zeros((N, N))

    for i in range(1, N - 1):
        for j in range(1, N - 1):
            # El campo eléctrico dentro de un conductor en equilibrio electrostático es 0
            if not mascara[i, j]:
                ex[i, j] = -(v[i+1, j] - v[i-1, j]) * max_steps
                ey[i, j] = -(v[i, j+1] - v[i, j-1]) * max_steps

    # 5. Visualización
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))

    # Líneas Equipotenciales
    contorno = ax1.contour(X, Y, v, levels=15, colors='black')
    ax1.set_title("Líneas equipotenciales (Círculo)")
    ax1.set_xlabel("X")
    ax1.set_ylabel("Y")
    ax1.set_aspect('equal')

    # Campo Eléctrico
    salto = max(1, N // 20) # Muestrea los vectores para que la flecha se vea clara
    ax2.quiver(X[::salto, ::salto], Y[::salto, ::salto], 
               ex[::salto, ::salto], ey[::salto, ::salto], 
               color='black', scale=max_steps*3)
    ax2.set_title("Campo eléctrico (Vectores)")
    ax2.set_xlabel("X")
    ax2.set_ylabel("Y")
    ax2.set_aspect('equal')

    plt.tight_layout()
    plt.show()

if __name__ == '__main__':
    resolver_laplace_forma_arbitraria()