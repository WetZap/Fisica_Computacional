# Bloque 3 — Esquema de Crank-Nicolson

Ecuación de Schrödinger 1D dependiente del tiempo en unidades reescaladas (ℏ = 1, m = 1/2):

$$i\,\partial_t\phi = \left[-\partial_x^2 + V(x)\right]\phi,$$

en una caja [0, L] con L = 1 y φ(0) = φ(L) = 0 (pozo infinito), discretizada con S = 1000 puntos. Crank-Nicolson es la aproximación de Cayley del propagador, (1 + iΔt H/2)⁻¹(1 − iΔt H/2): es **unitaria**, así que conserva la norma. Cada paso es un sistema tridiagonal que se resuelve con el algoritmo de Thomas.

En todas las simulaciones se calculan |φ|², la fase, la norma, ⟨x⟩, ⟨p⟩, ⟨H⟩ y Δx·Δp.

| Carpeta | Qué es | Estado |
|---|---|---|
| `Obligatorio/` | Partícula libre en una caja (V = 0) | ✅ |
| `Optativo/` | Oscilador armónico cuántico | ✅ Entregado |

---

## Obligatorio — Partícula en una caja

**Enunciado:** V = 0, L = 1, S = 1000. Hay que hacer las animaciones de Re φ, Im φ y |φ|², y representar la norma, ⟨x⟩, ⟨p⟩, ⟨H⟩ y Δx·Δp comparando con la teoría, para:
- las 3 primeras autofunciones, sin(nπx/L) con n = 1, 2, 3;
- un paquete gaussiano φ(x,0) = e^(ik₀x) e^(−(x−x₀)²/2σ²), con x₀ = L/4, σ = L/16 y k₀ = 1/(2√Δt), en este caso sin comparar con la teoría.

| Programa (`Scripts/`) | Estado inicial |
|---|---|
| `Schrodinger_Auto.f90` | Autoestado sin(nπx/L). **n se fija a mano** en la línea `orden = 3`; cámbialo para n = 1 y 2 |
| `Schrodinger_Func.f90` | Paquete gaussiano con los parámetros del enunciado |

`BashVideo.sh` compila los dos, los ejecuta en paralelo y deja los vídeos y gráficas en `Video/Auto` y `Video/Func`.

```bash
cd 3_CrankNicolson/Obligatorio
bash BashVideo.sh
```

---

## Optativo — Oscilador armónico cuántico (entregado)

> 📄 La **versión entregada**, con memoria en LaTeX, figuras, vídeos y Docker, está en [Propuestos_Computacional/Opcional_Schrodinger](https://github.com/WetZap/Propuestos_Computacional/tree/main/Opcional_Schrodinger). Esta carpeta es la versión de trabajo y su código difiere en algunos ficheros.

**Enunciado:** V(x) = (ω²/4)(x − 0,5)² con ω = 200, Δt = 10⁻⁴ y al menos t = 0,5. Se piden:
- Las mismas magnitudes que en el obligatorio para los primeros autoestados (Hermite).
- La probabilidad cuántica frente a la clásica para n ≥ 20 (principio de correspondencia de Bohr).
- Un paquete gaussiano con x₀ = 0,3 y σ = 1/16, comparado con el oscilador clásico de la misma energía; después, variar ω, σ y x₀.

| Fichero | Qué hace |
|---|---|
| `Scripts/Schrodinger_Auto.f90` | Autoestados Hₙ(αξ)·e^(−α²ξ²/2), con n pasado por argumento |
| `Scripts/Schrodinger_Func.f90` | Paquete gaussiano en el pozo armónico |
| `Scripts/Mov_Armonico_Clasico.f90` | Oscilador clásico equivalente, para comparar |
| `BashOpt.sh` | Barrido de n = 0…20 |
| `BashOptN.sh` | Los n de `VALORES_N` (por defecto 4) más la comparación clásico/cuántico |

```bash
cd 3_CrankNicolson/Optativo
bash BashOptN.sh
```
