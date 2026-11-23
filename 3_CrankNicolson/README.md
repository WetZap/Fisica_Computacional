# Parte 3 — Esquema de Crank-Nicolson

Resolución de la ecuación de Schrödinger dependiente del tiempo en 1D con el esquema implícito de Crank-Nicolson (sistema tridiagonal). En cada simulación se calculan |Φ|², la fase, ⟨x⟩, ⟨p⟩, la norma, el hamiltoniano y el producto Δx·Δp.

```
3_CrankNicolson/
├── Obligatorio/   # Pozo infinito
└── Optativo/      # Oscilador armónico cuántico vs. clásico
```

---

## Obligatorio

| Programa (`Scripts/`) | Estado inicial |
|---|---|
| `Schrodinger_Auto.f90` | Autoestado del pozo, sin(nπx/L) |
| `Schrodinger_Func.f90` | Paquete gaussiano con momento inicial |

`BashVideo.sh` compila ambos, los ejecuta en paralelo y genera los vídeos y gráficas en `Video/Auto` y `Video/Func`.

```bash
cd 3_CrankNicolson/Obligatorio
bash BashVideo.sh
```

---

## Optativo

Potencial armónico V(x) = (ω²/4)(x − 0,5)².

| Fichero | Qué hace |
|---|---|
| `Scripts/Schrodinger_Auto.f90` | Autoestados del oscilador (polinomios de Hermite Hₙ) |
| `Scripts/Schrodinger_Func.f90` | Paquete gaussiano en el pozo armónico |
| `Scripts/Mov_Armonico_Clasico.f90` | Oscilador clásico equivalente, para comparar |
| `BashOpt.sh` | Barrido de n = 0…20 |
| `BashOptN.sh` | Un solo n (por defecto `VALORES_N=(4)`) más la comparación clásico/cuántico |

```bash
cd 3_CrankNicolson/Optativo
bash BashOptN.sh
```
