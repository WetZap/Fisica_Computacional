# Física Computacional 🧮

Prácticas de la asignatura **Física Computacional** (3º del Grado en Física, Universidad de Granada). Las simulaciones están en **Fortran 90**, las gráficas y animaciones se hacen con **gnuplot** y los vídeos/GIF se ensamblan con **ffmpeg**, todo orquestado con scripts **bash**.

---

## 🗂️ Cómo se organizaba la asignatura

La asignatura tenía **cuatro bloques**, uno por método numérico. Cada bloque tenía un **problema obligatorio** y **al menos un optativo**. De los cuatro optativos había que entregar **dos, de bloques distintos**: yo hice el de **Schrödinger** y el de **Runge-Kutta**.

| Bloque | Ejercicio de clase | Obligatorio | Optativo propuesto | ¿Entregado? |
|---|---|---|---|---|
| [1 — Verlet](1_Verlet/) | Péndulo simple | Sistema solar | Gas de Lennard-Jones | ❌ Solo un borrador inicial |
| [2 — Monte Carlo](2_MonteCarlo/) | Números aleatorios, cálculo de π | Modelo de Ising 2D | Red neuronal de Hopfield | ❌ Exploratorio, sin verificar |
| [3 — Crank-Nicolson](3_CrankNicolson/) | — | Schrödinger 1D: partícula en una caja | Oscilador armónico cuántico | ✅ |
| [4 — Runge-Kutta](4_RungeKutta/) | — | Nave Tierra-Luna (problema restringido de 3 cuerpos) | Péndulo doble y caos | ✅ |

> 📄 **Optativos entregados:** la versión final, con memoria en LaTeX, figuras, vídeos y Docker para reproducirla, está en **[WetZap/Propuestos_Computacional](https://github.com/WetZap/Propuestos_Computacional)**. Las carpetas `Optativo/` de los bloques 3 y 4 son la versión de trabajo y su código no coincide exactamente con el entregado.

---

## 📁 Estructura

```
Fisica_Computacional/
├── 1_Verlet/
│   ├── Ejercicio_Pendulo/            # Ejercicio de introducción a Verlet
│   ├── Obligatorio/                  # Sistema solar
│   └── borradores/LennardJones_inicio/
├── 2_MonteCarlo/
│   ├── Ejercicio_NumerosAleatorios/
│   ├── Obligatorio/                  # Ising
│   └── Optativo/                     # Hopfield (sin verificar)
├── 3_CrankNicolson/
│   ├── Obligatorio/                  # Partícula en una caja
│   └── Optativo/                     # Oscilador armónico cuántico
└── 4_RungeKutta/
    ├── Obligatorio/                  # Cohete Tierra-Luna
    └── Optativo/                     # Péndulo doble
```

Dentro de cada práctica se sigue el mismo esquema:

```
<Práctica>/
├── Scripts/      # Código Fortran (.f90)
├── Animation/    # Plantillas de gnuplot (.plt)
├── *.sh          # Compilan, ejecutan y generan gráficas/vídeos
└── borradores/   # (si existe) versiones antiguas o de prueba, sin mantener
```

Las carpetas `Data/`, `Datos/`, `Images/`, `Gifs/` y `Video/` se crean al ejecutar y **no se suben** (ver `.gitignore`). Los únicos `.dat` versionados son los **ficheros de entrada** que leen los programas.

Cada README de bloque resume qué pedía el enunciado, qué está hecho y qué problemas conocidos hay.

---

## 🛠️ Requisitos

- `gfortran`, con OpenMP (`-fopenmp`) para el optativo de Runge-Kutta, que por defecto compila con Intel `ifx`
- `gnuplot`
- `ffmpeg`
- `bash`, `awk`, `bc` (Linux)

## ▶️ Ejecución

Cada práctica se ejecuta **desde su propia carpeta**, porque los programas leen y escriben con rutas relativas:

```bash
cd 4_RungeKutta/Obligatorio
bash Bash.sh
```

Para compilar un programa suelto, usa siempre `-o NOMBRE.out` (los `.out` están en el `.gitignore`). Algunas líneas pasan de 132 caracteres, así que hace falta `-ffree-line-length-none`:

```bash
gfortran -O3 -ffree-line-length-none Scripts/Programa.f90 -o Programa.out && ./Programa.out
```

---

## 👤 Autor

**Jorge del Río López** — Grado en Física, Universidad de Granada (UGR)

## 📄 Licencia

Uso académico. Consultar con el autor antes de reutilizar el código. Los enunciados son material de la asignatura y no se incluyen en el repositorio.
