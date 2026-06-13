# Física Computacional 🧮

Repositorio de prácticas y ejercicios entregables de la asignatura **Física Computacional** de la Universidad de Granada (UGR). Implementa los principales métodos numéricos utilizados en física mediante simulaciones computacionales.

---

## 📁 Estructura del proyecto

```
FisicaComp/
├── 1_PrimeraParte_Verlet/          # Integración numérica con el algoritmo de Verlet
│   ├── Tarea1/
│   ├── TareaEntregable/
│   └── EjercicioEntregable/
├── 2_SegundaParte_MonteCarlo/      # Métodos estocásticos de Monte Carlo
├── 3_TerceraParte_Crank_Nicholson/ # Esquema implícito de Crank-Nicholson (EDPs)
└── 4_CuartaParte_RungeKutta/       # Integración de EDOs con Runge-Kutta
```

---

## 📚 Contenido

### Parte 1 — Algoritmo de Verlet
Implementación del integrador de Verlet para resolver ecuaciones de movimiento en sistemas físicos. Se aplica a problemas de dinámica molecular y mecánica clásica, conservando la energía a lo largo de la trayectoria.

### Parte 2 — Métodos de Monte Carlo
Simulaciones basadas en muestreo aleatorio para calcular integrales y estudiar sistemas estadísticos. Incluye aplicaciones en física estadística y estimación de magnitudes físicas.

### Parte 3 — Esquema de Crank-Nicholson
Resolución numérica de ecuaciones en derivadas parciales (EDPs) mediante el esquema implícito de Crank-Nicholson. Especialmente útil para la ecuación de calor y la ecuación de difusión, garantizando estabilidad incondicional.

### Parte 4 — Runge-Kutta
Integración de ecuaciones diferenciales ordinarias (EDOs) mediante métodos de Runge-Kutta de orden 4 (RK4). Se aplica a osciladores, problemas de dos cuerpos y otros sistemas dinámicos.

---

## 🛠️ Requisitos

- Compilador Fortran (p. ej. `gfortran`) o C (`gcc`)
- `gnuplot` o Python con `matplotlib` para la visualización de resultados
- Sistema operativo Linux/macOS recomendado

## ▶️ Compilación y ejecución

```bash
# Ejemplo para Fortran
gfortran -o programa programa.f90
./programa

# Ejemplo para C
gcc -o programa programa.c -lm
./programa
```

---

## 👤 Autor

**Jorge Del Rio** — Grado en Física, Universidad de Granada (UGR)

---

## 📄 Licencia

Este repositorio es de uso académico. Consultar con el autor antes de reutilizar el código.
