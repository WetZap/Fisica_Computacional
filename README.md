# Física Computacional 🧮

Prácticas y entregables de la asignatura **Física Computacional** del Grado en Física de la Universidad de Granada (UGR). Las simulaciones están en **Fortran 90**, las gráficas y animaciones se hacen con **gnuplot** y los vídeos/GIF se ensamblan con **ffmpeg**, todo orquestado con scripts **bash**.

---

## 📁 Estructura

```
Fisica_Computacional/
├── 1_Verlet/            # Integrador de Verlet: sistema solar, gas de partículas, péndulo
├── 2_MonteCarlo/        # Números aleatorios, modelo de Ising, red de Hopfield
├── 3_CrankNicolson/     # Ecuación de Schrödinger 1D con Crank-Nicolson
└── 4_RungeKutta/        # RK4: viaje Tierra-Luna y péndulo doble caótico
```

Todas las prácticas siguen el mismo esquema:

```
<Práctica>/
├── README.md     # Qué hace cada programa y cómo ejecutarlo
├── Scripts/      # Código Fortran (.f90)
├── Animation/    # Plantillas de gnuplot (.plt)
├── *.sh          # Scripts que compilan, ejecutan y generan gráficas/vídeos
└── borradores/   # (si existe) versiones antiguas o de prueba, sin mantener
```

Las carpetas `Data/`, `Datos/`, `Images/`, `Gifs/` y `Video/` se crean al ejecutar y **no se suben** (ver `.gitignore`). Los únicos `.dat` versionados son los **ficheros de entrada** que leen los programas.

---

## 📚 Contenido

| Parte | Método | Problemas |
|---|---|---|
| [1 — Verlet](1_Verlet/) | Verlet en velocidades | Sistema solar (órbitas, periodos, energía y momento angular), gas de 100 partículas con potencial tipo Lennard-Jones, péndulo simple |
| [2 — Monte Carlo](2_MonteCarlo/) | Metropolis | Generador de aleatorios y cálculo de π, modelo de Ising 2D (transición de fase), red de Hopfield (memoria asociativa) |
| [3 — Crank-Nicolson](3_CrankNicolson/) | Esquema implícito | Schrödinger 1D: pozo infinito (autoestados y paquete gaussiano) y oscilador armónico cuántico vs. clásico |
| [4 — Runge-Kutta](4_RungeKutta/) | RK4 | Nave Tierra-Luna en el sistema rotante; péndulo doble: mapas de Poincaré y exponente de Lyapunov |

---

## 🛠️ Requisitos

- `gfortran` (algunos programas de la Parte 4 usan OpenMP: `-fopenmp`)
- `gnuplot`
- `ffmpeg` (vídeos y GIF)
- `bash`, `awk`, `bc` (Linux)

## ▶️ Ejecución

Cada práctica se ejecuta **desde su propia carpeta**, porque los programas escriben y leen con rutas relativas:

```bash
cd 4_RungeKutta/Obligatorio
bash Bash.sh
```

Para compilar un programa suelto, usa siempre `-o NOMBRE.out` (los `.out` están en el `.gitignore`):

```bash
gfortran -O3 -ffree-line-length-none Scripts/Programa.f90 -o Programa.out && ./Programa.out
```

---

## 👤 Autor

**Jorge del Río López** — Grado en Física, Universidad de Granada (UGR)

## 📄 Licencia

Uso académico. Consultar con el autor antes de reutilizar el código.
