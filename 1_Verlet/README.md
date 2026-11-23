# Parte 1 — Algoritmo de Verlet

Integración de las ecuaciones de movimiento con el algoritmo de Verlet en velocidades.

```
1_Verlet/
├── Tarea1_SistemaSolar/          # Órbitas del sistema solar
├── TareaEntregable_Particulas/   # Gas de partículas en una caja 2D
└── EjercicioEntregable_Pendulo/  # Péndulo simple (apartados 1-3, 4 y 6)
```

> Los programas de esta parte escriben en subcarpetas (`Datos/...`) que **deben existir** antes de ejecutar: Fortran no las crea. Cada sección indica el `mkdir -p` necesario.

---

## Tarea1_SistemaSolar

Simulación del sistema solar con interacción gravitatoria entre todos los cuerpos.

| Fichero | Qué hace |
|---|---|
| `Scripts/Tarea1.1.f90` | Integra las órbitas. Escribe `Datos/DatosOut/datos_out_*.dat`, la Luna (`Luna.dat`) y la energía y el momento angular (`Datos/EnergiaMomento/`) |
| `Scripts/TareaTierra.f90` | Movimiento de los planetas vistos desde la Tierra → `Datos/Tierra/` |
| `Scripts/Periodo.f90` | Calcula los periodos orbitales y su error → `Datos/Periodos/` |
| `SistemaRapido.sh` | Genera en paralelo los GIF de las órbitas (con/sin Luna, con/sin rastro, vista desde la Tierra) |
| `EnergiaMome.sh` | Gráficas de energía y momento angular |

**Entrada necesaria:** `Datos/Inicial/planetas.dat` (posiciones y velocidades iniciales) y `Datos/Inicial/Masas.dat`.

```bash
cd 1_Verlet/Tarea1_SistemaSolar
mkdir -p Datos/DatosOut Datos/EnergiaMomento Datos/Tierra Datos/Periodos
gfortran -O3 -ffree-line-length-none Scripts/Tarea1.1.f90 -o Tarea1.out && ./Tarea1.out
gfortran -O3 -ffree-line-length-none Scripts/TareaTierra.f90 -o TareaTierra.out && ./TareaTierra.out
gfortran -O3 -ffree-line-length-none Scripts/Periodo.f90 -o Periodo.out && ./Periodo.out
bash SistemaRapido.sh && bash EnergiaMome.sh
```

`borradores/Test/` guarda una versión anterior de la tarea y de las plantillas de animación.

---

## TareaEntregable_Particulas

`Scripts/Tarea1.f90`: 100 partículas en una caja de lado L = 22 con velocidades iniciales de módulo 1 en direcciones aleatorias, interactuando con un potencial tipo Lennard-Jones. Escribe la trayectoria de cada partícula en `Datos/datos_*.dat`.

```bash
cd 1_Verlet/TareaEntregable_Particulas
mkdir -p Datos
gfortran -O3 -ffree-line-length-none Scripts/Tarea1.f90 -o Tarea1.out && ./Tarea1.out
```

---

## EjercicioEntregable_Pendulo

Péndulo simple resuelto con Verlet para varios ángulos iniciales.

| Fichero | Qué hace |
|---|---|
| `Scripts/Ejercicio.f90` | Apartados 1-3. Lee las condiciones iniciales (θ₀, θ̇₀) de `Iniciales.dat`; escribe trayectorias (`Datos/datos*.dat`), energías (`Datos/Energias/`), `Periodos.dat` y `PeriodosAjuste.dat` |
| `Apartado123.sh` | GIF del espacio xy, del espacio de fases y de la energía, más la gráfica de periodos |
| `Apartado4/` | Variante del apartado 4 (`Scripts/Ejercicio3.f90` + `Apartado4.sh`); usa su propio `Iniciales.dat` |
| `Apartado6/` | `Scripts/Algoritmo2.0.f90`: péndulo con θ₀ = π/4 y h = 0,1, comparando periodo y energía con los teóricos |

**Entrada necesaria:** `Iniciales.dat` (y `Apartado4/Iniciales.dat`).

```bash
cd 1_Verlet/EjercicioEntregable_Pendulo
mkdir -p Datos/Energias
gfortran -O3 -ffree-line-length-none Scripts/Ejercicio.f90 -o Ejercicio.out && ./Ejercicio.out
bash Apartado123.sh
```
