# Bloque 4 — Runge-Kutta de orden 4

Integración de sistemas de EDO de primer orden y′ = f(t, y) con RK4:

$$y_{n+1} = y_n + \tfrac{h}{6}(k_1 + 2k_2 + 2k_3 + k_4).$$

| Carpeta | Qué es | Estado |
|---|---|---|
| `Obligatorio/` | Nave Tierra-Luna (problema restringido de tres cuerpos) | ✅ Con paso fijo (ver notas) |
| `Optativo/` | Péndulo doble y caos | ✅ Entregado |

---

## Obligatorio — Nave Tierra-Luna

**Modelo:** la Tierra está fija en el origen y la Luna gira en una órbita circular de radio d_TL con ω = 2,6617·10⁻⁶ s⁻¹. La nave se integra en polares (r, φ, p_r, p_φ) con las variables reescaladas por d_TL y la masa de la nave.

**Enunciado:** escribir el programa, comparar trayectorias y tiempos de cálculo con h fija y con **RK adaptativo**, demostrar que H′ = H − ω p_φ es constante del movimiento y usarlo para medir el error acumulado.

Las cuatro tareas comparten el código y solo cambian las condiciones de lanzamiento:

| Programa (`Scripts/`) | Latitud | Ángulo θ | Velocidad (m/s) |
|---|---|---|---|
| `RungeKuta_Tarea1.f90` | π/2 | 0 | 7903,75 |
| `RungeKuta_Tarea2.f90` | π/4 | π/2 | 10 000 |
| `RungeKuta_Tarea3.f90` | π/4 | π/2 | 14 000 |
| `RungeKuta_Tarea4.f90` | π/2 | π/3,38 | 11 200 |

`Bash.sh` compila y ejecuta las cuatro, y genera la animación de la órbita (con la Luna) y la gráfica de H′ para cada una. Los resultados quedan en `Data/TareaN/`.

```bash
cd 4_RungeKutta/Obligatorio
bash Bash.sh
```

**Notas:**
- Solo se usa **paso fijo** (h = 0,1). El RK adaptativo y la comparación h fija/adaptativo que pedía el enunciado no están en este código.
- Las tareas 1-3 usan G = 6,67430·10⁻¹¹, M_T = 5,972·10²⁴ kg y M_L = 7,348·10²² kg. La tarea 4 y el enunciado usan 6,67·10⁻¹¹, 5,9736·10²⁴ y 7,349·10²². La diferencia es mínima, pero conviene unificarla.

---

## Optativo — Péndulo doble y caos (entregado)

> 📄 La **versión entregada**, con memoria en LaTeX, figuras, vídeos y Docker, está en [Propuestos_Computacional/Opcional_RungeKutta](https://github.com/WetZap/Propuestos_Computacional/tree/main/Opcional_RungeKutta). Esta carpeta es la versión de trabajo: `Bash.sh`, `Lyapunov.plt` y `Opcional_KuttaThetaMax.f90` difieren de la entregada (aquí ThetaMax usa paso 0,00008 y 5000 energías; allí, 0,01 y 3500).

**Enunciado:** m₁ = 3, m₂ = 1, l₁ = 2, l₂ = 1, g = 1. Los cuatro puntos de equilibrio tienen energías E₁ = −9, E₂ = −7, E₃ = 7 y E₄ = 9. Se fijan tres condiciones iniciales y la energía, y la cuarta se despeja de T + V = E. Basado en Stachowiak & Okada, *Chaos, Solitons and Fractals* **29**, 417 (2006).

| Fichero (`Scripts/`) | Tarea del enunciado | Energías |
|---|---|---|
| `Scripts_Temporal/Opcional_Kutta*Temp.f90` | 1-2. θ(t) y proyecciones ω₁(θ₁), ω₂(θ₂) | las mismas que en Poincaré |
| `Opcional_Kutta1..4.f90` | 3-4. Secciones de Poincaré ω₂(θ₂) con θ₁ = 0, ω₁ > 0 | −9 + 0,01 · **−7 + 0,01** · 7 − 0,01 · 9 − 0,01 |
| `Opcional_KuttaThetaMax.f90` | 5-6. Diagrama de bifurcación θ₂,max(E) | barrido de E |
| `Opcional_Kutta_Lyapunov.f90` | 7. Exponente de Lyapunov | −9 + 0,01 · −7 − 0,01 · 7 − 0,01 |

> El enunciado pide la sección de Poincaré para **E₂ − 0,01**; `Opcional_Kutta2` usa E₂ + 0,01, aunque el Lyapunov sí usa −7 − 0,01. El caso E₄ − 0,01 es un añadido sobre lo que pedía el enunciado.

`Bash.sh` lo compila y ejecuta todo, paralelizado con **OpenMP**, y genera las animaciones y gráficas.

```bash
cd 4_RungeKutta/Optativo
bash Bash.sh
```

> **Compilador:** por defecto usa **Intel `ifx`** (`Compilacion_INTEL`, que carga `/opt/intel/oneapi/setvars.sh`). Si no tienes oneAPI, comenta `Compilacion_INTEL` y descomenta `#Compilacion_gfortran` hacia la línea 370 del script.
