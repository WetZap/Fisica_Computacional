# Bloque 1 — Algoritmo de Verlet

Integración de las ecuaciones de Newton con el algoritmo de Verlet en velocidades:

$$w = v + \tfrac{h}{2}a(x),\qquad x \leftarrow x + h\,w,\qquad v = w + \tfrac{h}{2}a(x).$$

| Carpeta | Qué es | Estado |
|---|---|---|
| `Ejercicio_Pendulo/` | Ejercicio de introducción: péndulo simple | ✅ |
| `Obligatorio/` | Simulación del sistema solar | ✅ |
| `borradores/LennardJones_inicio/` | Arranque del optativo de gas de Lennard-Jones | ❌ No realizado |

> Los programas de este bloque escriben en subcarpetas (`Datos/...`) que **deben existir** antes de ejecutar, porque Fortran no las crea. Cada sección indica el `mkdir -p` necesario.

---

## Ejercicio_Pendulo — Péndulo simple

**Enunciado:** integrar θ̈ + (g/l) sin θ = 0 con m = l = 1 y h = 0,01 para las condiciones iniciales (θ, θ̇) = (0,0), (π/18,0), (π/4,0), (π/2,0), (3π/4,0), (17π/18,0), (π,0), (π,−0,1) y (π,−1).

| Tarea | Dónde |
|---|---|
| 2. Animación en el plano xy | `Scripts/Ejercicio.f90` + `Apartado123.sh` (`animacionxy.plt`) |
| 3. Espacio de fases θ̇(θ) con la curva teórica | `Apartado123.sh` (`animacionfase.plt`) |
| 4. θ(t) frente a la aproximación de ángulos pequeños, para π/18 y π/2 | `Apartado4/` |
| 5. Energías cinética, potencial y total | `Apartado123.sh` (`animacionener.plt`) |
| 6. Repetir con h = 0,1 para (π/4, 0) | `Apartado6/Scripts/Algoritmo2.0.f90` |
| 7. Periodo T/T₀ frente al ángulo inicial | `Ejercicio.f90` → `Periodos.dat`, `PeriodosAjuste.dat` + `animacionperio.plt` |

**Entrada — `Iniciales.dat`** (y `Apartado4/Iniciales.dat`): una condición inicial por línea, `θ₀/π  θ̇₀`. La primera columna va **en unidades de π** y admite fracciones:

```
1/18 0
1/2 0
1 -0.1
```

```bash
cd 1_Verlet/Ejercicio_Pendulo
mkdir -p Datos/Energias
gfortran -O3 -ffree-line-length-none Scripts/Ejercicio.f90 -o Ejercicio.out && ./Ejercicio.out
bash Apartado123.sh
```

---

## Obligatorio — Sistema solar

**Enunciado:** simular el sistema solar con datos reales (distancias, masas, excentricidades) y **todas** las interacciones gravitatorias entre cuerpos. Las variables están reescaladas con c = 1,496·10¹¹ m y la masa solar, así que 1 unidad de tiempo ≈ 58,1 días.

| Tarea | Dónde |
|---|---|
| Animación de las órbitas alrededor del Sol | `Scripts/Tarea1.1.f90` + `SistemaRapido.sh` (con/sin Luna, con/sin rastro) |
| Animación en el modelo geocéntrico | `Scripts/TareaTierra.f90` + `SistemaRapido.sh` (`Tierra.plt`, `TierraR.plt`) |
| Periodo de los 5 primeros planetas frente a los datos reales | `Scripts/Periodo.f90` → `Datos/Periodos/PeriodosError.dat` |
| Conservación de la energía total | `Tarea1.1.f90` → `Datos/EnergiaMomento/Energia.dat` + `EnergiaMome.sh` |
| Conservación del momento angular | `Tarea1.1.f90` → `Datos/EnergiaMomento/Momento_angular.dat` + `EnergiaMome.sh` |

**Entrada** (datos de la *Planetary Fact Sheet* de la NASA, <https://nssdc.gsfc.nasa.gov/planetary/factsheet/>). Son 10 cuerpos, uno por línea y **en este orden**: Sol, Mercurio, Venus, Tierra, Marte, Júpiter, Saturno, Urano, Neptuno, Plutón.

- `Datos/Inicial/planetas.dat`: `x  y  vx  vy`, con posiciones en 10⁶ km y velocidades en km/s.
- `Datos/Inicial/Masas.dat`: una masa por línea, en 10²⁴ kg. La Tierra tiene que valer **exactamente `5.97`**: el programa la localiza por su masa para colocar la Luna.
- `Datos/Inicial/periodos.dat`: los periodos reales de Mercurio a Neptuno (7 valores, uno por línea, en las mismas unidades en que `Periodo.f90` mide los simulados). `Periodo.f90` los usa para calcular el error relativo. Si falta el fichero, no da error: abre con `status='unknown'` y el periodo teórico queda sin definir.

> La Luna se integra después y solo con la gravedad de la Tierra, como un problema de dos cuerpos (masa total M_T + M_L) en el sistema de la Tierra. No interacciona con el Sol ni con los demás planetas.

```bash
cd 1_Verlet/Obligatorio
mkdir -p Datos/DatosOut Datos/EnergiaMomento Datos/Tierra Datos/Periodos
gfortran -O3 -ffree-line-length-none Scripts/Tarea1.1.f90 -o Tarea1.out && ./Tarea1.out
gfortran -O3 -ffree-line-length-none Scripts/TareaTierra.f90 -o TareaTierra.out && ./TareaTierra.out
gfortran -O3 -ffree-line-length-none Scripts/Periodo.f90 -o Periodo.out && ./Periodo.out
bash SistemaRapido.sh && bash EnergiaMome.sh
```

`borradores/Test/` guarda una versión anterior de la tarea.

---

## Optativo (no realizado) — Gas de Lennard-Jones

El optativo pedía una dinámica molecular 2D de argón con V(r) = 4[(1/r)¹² − (1/r)⁶], corte en r = 3, condiciones de contorno periódicas con mínima imagen y 100 partículas en una caja de 22×22 con Δt = 0,002. Después había que estudiar la termalización, la distribución de Maxwell, la ecuación de estado, la transición sólido-líquido y g(r).

`borradores/LennardJones_inicio/Scripts/Tarea1.f90` es solo el arranque (condiciones iniciales y esqueleto de Verlet) y **no funciona como simulación de Lennard-Jones**:

- `r(j)` es la distancia de cada partícula **al origen**, no la distancia entre el par i–j.
- La fuerza `((48/r)**7 − (24/r)**4)·x` no corresponde a F = 24(2/r¹³ − 1/r⁷)·r⃗/r.
- Cuando r > 3, el corte pone a cero **toda** la aceleración acumulada, en vez de saltarse solo ese par.
- No hay condiciones periódicas.
