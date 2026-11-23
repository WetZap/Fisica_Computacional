# Parte 2 — Métodos de Monte Carlo

```
2_MonteCarlo/
├── NumerosAleatorios/   # Pruebas del generador y cálculo de π
├── ModeloIsing/         # Ising 2D con Metropolis
└── ModeloHopfield/      # Red de Hopfield (memoria asociativa)
```

---

## NumerosAleatorios

| Fichero | Qué hace |
|---|---|
| `Scripts/NumerosAleatorios.f90` | Media y segundo momento de reales en [0,1) y de enteros en [1, m] |
| `Scripts/Calculo_pi.f90` | Estimación de π por Monte Carlo |

Escriben por pantalla, sin ficheros:

```bash
cd 2_MonteCarlo/NumerosAleatorios
gfortran -ffree-line-length-none Scripts/Calculo_pi.f90 -o Calculo_pi.out && ./Calculo_pi.out
```

---

## ModeloIsing

Red de espines 50×50 con el algoritmo de Metropolis, barriendo temperaturas para ver la transición de fase.

| Programa (`Scripts/`) | Script que lo lanza | Variante |
|---|---|---|
| `Modelov2.f90` | `BashVideo.sh` → `BashImagen.sh` | Configuración inicial aleatoria |
| `Modelov2Ordenado.f90` | `BashVideoOrde.sh` → `BashImagenOrde.sh` | Configuración inicial ordenada |
| `Modelo_Sin_Interaccion.f90` | `BashSin.sh` → `BashImagenSin.sh` | Espines sin interacción (control) |

Cada `BashVideo*.sh` compila, ejecuta, genera un vídeo por temperatura (`Video/`) y al final llama a su `BashImagen*.sh`, que dibuja magnetización y energía frente a T (`Images/`).

```bash
cd 2_MonteCarlo/ModeloIsing
bash BashVideo.sh
```

`borradores/` contiene la primera versión (`ModeloIsingLento/`, cuyo `Bash.sh` nunca llegó a funcionar), `Modelo_v1.f90` y plantillas de gnuplot de prueba.

---

## ModeloHopfield

Red de Hopfield de 150×150 neuronas que recupera patrones almacenados.

| Fichero | Qué hace |
|---|---|
| `Scripts/Modelov2.f90` | Un patrón (`Patrones/Patron1.dat`) a T ≈ 0 → `Data/Datos/datos.dat` (binario) |
| `Scripts/Modelov2_Mult.f90` | Patrón de `Patrones/Patron2.dat`, varias iteraciones a T ≈ 0, una por fichero → `Data/Datos/datos_*.dat` y `Temperaturas.dat` |
| `BashVideo.sh` | Convierte cada `datos*.dat` binario en vídeo |

**Entrada necesaria:** `Patrones/Patron1.dat` y `Patrones/Patron2.dat`.

> Los `.f90` usan rutas `../Patrones` y `../Data`, así que hay que **ejecutarlos desde `Scripts/`**. `BashVideo.sh` no compila; solo procesa datos ya generados.

```bash
cd 2_MonteCarlo/ModeloHopfield
mkdir -p Data/Datos
cd Scripts && gfortran -O3 -ffree-line-length-none Modelov2_Mult.f90 -o Modelov2_Mult.out && ./Modelov2_Mult.out && cd ..
bash BashVideo.sh
```

⚠️ En `BashVideo.sh`, `N="$temperaturas[1]"` no da un número, así que el cálculo de `num_frames` falla. Si la red es de 150×150, debería ser `N=150`. No lo he cambiado porque no tengo claro qué intención había.
