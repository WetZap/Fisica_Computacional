# Parte 4 — Runge-Kutta de orden 4

```
4_RungeKutta/
├── Obligatorio/   # Nave Tierra-Luna
└── Optativo/      # Péndulo doble y caos
```

---

## Obligatorio

Nave lanzada desde la Tierra hacia la Luna, integrada con RK4 en coordenadas polares (r, φ, p_r, p_φ) con las variables reescaladas.

Las cuatro tareas comparten el mismo código y solo cambian las condiciones de lanzamiento:

| Programa (`Scripts/`) | Latitud | Ángulo θ | Velocidad (m/s) |
|---|---|---|---|
| `RungeKuta_Tarea1.f90` | π/2 | 0 | 7903,75 |
| `RungeKuta_Tarea2.f90` | π/4 | π/2 | 10 000 |
| `RungeKuta_Tarea3.f90` | π/4 | π/2 | 14 000 |
| `RungeKuta_Tarea4.f90` | π/2 | π/3,38 | 11 200 |

`Bash.sh` compila y ejecuta las cuatro, y genera la animación de la órbita (con la Luna) y la gráfica del hamiltoniano H' en el sistema rotante, para comprobar que se conserva. Los resultados quedan en `Data/TareaN/`.

```bash
cd 4_RungeKutta/Obligatorio
bash Bash.sh
```

---

## Optativo

Péndulo doble resuelto con RK4 y paralelizado con **OpenMP** (`-fopenmp`).

| Fichero (`Scripts/`) | Qué hace |
|---|---|
| `Opcional_Kutta1..4.f90` | Mapas de Poincaré para E = −9, −7, 7 y 9 (±0,01) |
| `Scripts_Temporal/Opcional_Kutta*Temp.f90` | Evolución temporal y espacio de fases para esas energías |
| `Opcional_KuttaThetaMax.f90` | θ₂ máximo en función de la energía |
| `Opcional_Kutta_Lyapunov.f90` | Exponente de Lyapunov |

`Bash.sh` lo compila y ejecuta todo, y genera las animaciones y gráficas de Poincaré, de proyecciones y de Lyapunov.

> **Compilador:** por defecto usa **Intel `ifx`** (`Compilacion_INTEL`, carga `/opt/intel/oneapi/setvars.sh`). Si no tienes oneAPI, comenta `Compilacion_INTEL` y descomenta `#Compilacion_gfortran` hacia la línea 370 del script.

```bash
cd 4_RungeKutta/Optativo
bash Bash.sh
```
