# Bloque 2 — Métodos de Monte Carlo

Muestreo de la distribución de Boltzmann con el algoritmo de **Metropolis**: se propone voltear un espín al azar y se acepta con probabilidad min(1, e^(−ΔE/T)). Un **paso Monte Carlo (pMC)** son N² intentos.

| Carpeta | Qué es | Estado |
|---|---|---|
| `Ejercicio_NumerosAleatorios/` | Ejercicios de clase con el generador aleatorio | ✅ |
| `Obligatorio/` | Modelo de Ising 2D | ⚠️ Hecho, pero no se ajusta del todo al enunciado (ver abajo) |
| `Optativo/` | Red neuronal de Hopfield | ❌ Exploratorio: lo probé, pero no está comprobado ni se entregó |

---

## Ejercicio_NumerosAleatorios

| Programa (`Scripts/`) | Qué hace |
|---|---|
| `NumerosAleatorios.f90` | Media y segundo momento de reales en [0,1) y de enteros en [1, m] |
| `Calculo_pi.f90` | Estimación de π por Monte Carlo |

Ambos escriben por pantalla:

```bash
cd 2_MonteCarlo/Ejercicio_NumerosAleatorios
gfortran -ffree-line-length-none Scripts/Calculo_pi.f90 -o Calculo_pi.out && ./Calculo_pi.out
```

---

## Obligatorio — Modelo de Ising 2D

Red de 50×50 con condiciones de contorno periódicas.

### Qué pedía el enunciado

**Sin interacción** (espines independientes en un campo, E = −Σ s):
- Animación (1 frame por pMC) para T = 4 y T = 0,1.
- Energía y magnetización medias por espín para T = 4, 3, 2,27, 2, 1 y 0,1, midiendo cada 50 pMC durante 10⁴ pMC y comparando con la teoría (m = tanh(1/T), e = −tanh(1/T)).

**Con interacción** (E = −½ Σ s_ij (suma de los 4 vecinos)):
- Animaciones a T = 0,1 y T = 2,27 desde una configuración desordenada, y a T = 4 desde una ordenada (todos los espines a +1).
- Energía y magnetización medias por espín para las mismas T, con el mismo protocolo de medida.

### Qué hay

| Programa (`Scripts/`) | Script | Configuración inicial | Temperaturas |
|---|---|---|---|
| `Modelo_Sin_Interaccion.f90` | `BashSin.sh` → `BashImagenSin.sh` | Aleatoria | 15 valores aleatorios en [0, 5] |
| `Modelov2.f90` | `BashVideo.sh` → `BashImagen.sh` | Aleatoria | 420 valores aleatorios en [0, 5] |
| `Modelov2Ordenado.f90` | `BashVideoOrde.sh` → `BashImagenOrde.sh` | Ordenada (+1) | Barrido de 0,06 a 5,01 en pasos de 0,05 |

Cada `BashVideo*.sh` compila, ejecuta, genera un vídeo por temperatura en `Video/` y llama a su `BashImagen*.sh`, que dibuja magnetización y energía frente a T en `Images/`.

```bash
cd 2_MonteCarlo/Obligatorio
bash BashVideo.sh
```

### ⚠️ Problemas conocidos (respecto al enunciado)

1. **La energía con interacción está mal medida.** `Modelov2.f90` y `Modelov2Ordenado.f90` calculan `energia_instantanea = −Σ s`, que es la fórmula del modelo **sin** interacción. Debería ser E = −Σ s_ij (s_i+1,j + s_i,j+1). En la práctica la "energía" por espín es −m: a T baja vale ±1, según hacia dónde se ordene la red, en vez de −2. La ΔE de Metropolis sí está bien, así que la dinámica y las animaciones son correctas; solo falla la energía que se mide.
2. **Simulaciones cortas.** `limite_tiempo` cuenta intentos de volteo, no pMC: 250 000 intentos son **100 pMC** con interacción, y 2 500 000 son 1000 pMC sin interacción. El enunciado pide 10⁴ pMC.
3. **Se mide en cada pMC, no cada 50,** y desde el primer paso, sin descartar la termalización. `cont` se reinicia cada N² intentos, así que `mod(cont, 100·N²) == 0` se cumple en cada pMC.
4. **Temperaturas aleatorias** en vez de las fijadas (4, 3, 2,27, 2, 1, 0,1).

El modelo sin interacción sí es coherente con su teoría: ΔE = 2s, E = −Σ s y las curvas tanh(1/T) de `MagnetizacionSin.plt` y `EnergiaSin.plt`.

`borradores/` guarda la primera versión (`ModeloIsingLento/`, cuyo `Bash.sh` nunca llegó a funcionar), `Modelo_v1.f90` y plantillas de gnuplot de prueba.

---

## Optativo (exploratorio, sin verificar) — Red de Hopfield

**Enunciado (resumen):** red 2D de neuronas sᵢⱼ ∈ {0, 1} con pesos hebbianos ω construidos a partir de P patrones, umbral θᵢⱼ = ½ Σ ω, dinámica de Metropolis a T = 10⁻⁴ y una red de al menos 30×30. Había que:

1. Recuperar un patrón desde un estado aleatorio y desde el patrón deformado, dando el solapamiento m(t).
2. Representar el solapamiento frente a T.
3. Repetir con varios patrones.
4. Hallar la capacidad α_c = P_c/N² con N = 20 y patrones aleatorios.

| Fichero | Qué hace |
|---|---|
| `Scripts/Modelov2.f90` | Un patrón (`Patrones/Patron1.dat`), red de 150×150 a T = 10⁻⁵ → `Data/Datos/datos.dat` (binario) |
| `Scripts/Modelov2_Mult.f90` | Patrón de `Patrones/Patron2.dat` con un barrido de 10 temperaturas, T = 10⁻⁵·2,5ˡ (de 2,5·10⁻⁵ a ≈ 0,095), un fichero por temperatura |
| `BashVideo.sh` | Convierte cada `datos*.dat` binario en vídeo |

Lo que **no** hay: no se guarda el solapamiento en función del tiempo, no hay varios patrones a la vez ni cálculo de α_c, y no se ha comprobado que los resultados sean correctos.

**Entrada:** `Patrones/Patron1.dat` y `Patron2.dat`, con 150 filas de 150 caracteres `0`/`1` seguidos, sin espacios. El enunciado recomienda <https://www.dcode.fr/binary-image> para convertir una imagen en blanco y negro a este formato.

> Los `.f90` usan las rutas `../Patrones` y `../Data`, así que hay que **ejecutarlos desde `Scripts/`**. `BashVideo.sh` no compila; solo procesa datos ya generados. En `BashVideo.sh`, `N="$temperaturas[1]"` no da un número y el cálculo de `num_frames` falla (debería ser `N=150`).

```bash
cd 2_MonteCarlo/Optativo
mkdir -p Data/Datos
cd Scripts && gfortran -O3 -ffree-line-length-none Modelov2_Mult.f90 -o Modelov2_Mult.out && ./Modelov2_Mult.out && cd ..
bash BashVideo.sh
```
