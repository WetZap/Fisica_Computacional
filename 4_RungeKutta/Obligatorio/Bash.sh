#!/usr/bin/env bash
set -Eeuo pipefail

# ─── Temporizador ────────────────────────────────────────────────────────────
T_TOTAL_INICIO=$(date +%s%3N)

fmt_tiempo() {
    local ms=$1
    local seg=$(( ms / 1000 ))
    local ms_resto=$(( ms % 1000 ))
    local min=$(( seg / 60 ))
    local seg_resto=$(( seg % 60 ))
    printf "%dm %ds %dms" "$min" "$seg_resto" "$ms_resto"
}

fase() {
    local nombre="$1"
    local inicio="$2"
    local fin
    fin=$(date +%s%3N)
    printf "  %-35s → %s\n" "$nombre" "$(fmt_tiempo $(( fin - inicio )))"
}

echo "====================================="
echo " SIMULACIÓN Runge-Kutta"
echo "====================================="

# ─── Rutas ───────────────────────────────────────────────────────────────────
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DIR_DATOS_OUT="$DIR/Data/Tarea1"
DIR_DATOS_OUT_2="$DIR/Data/Tarea2"
DIR_DATOS_OUT_3="$DIR/Data/Tarea3"
DIR_DATOS_OUT_4="$DIR/Data/Tarea4"

DIR_GIFS_SISTEMA="$DIR/Video/Tarea1"
DIR_GIFS_SISTEMA_2="$DIR/Video/Tarea2"
DIR_GIFS_SISTEMA_3="$DIR/Video/Tarea3"
DIR_GIFS_SISTEMA_4="$DIR/Video/Tarea4"

DIR_SCRIPT="$DIR/Scripts/RungeKuta_Tarea1.f90"
DIR_EJECUTABLE="$DIR/Scripts/RungeKuta_Tarea1.out"
DIR_SCRIPT_2="$DIR/Scripts/RungeKuta_Tarea2.f90"
DIR_EJECUTABLE_2="$DIR/Scripts/RungeKuta_Tarea2.out"
DIR_SCRIPT_3="$DIR/Scripts/RungeKuta_Tarea3.f90"
DIR_EJECUTABLE_3="$DIR/Scripts/RungeKuta_Tarea3.out"
DIR_SCRIPT_4="$DIR/Scripts/RungeKuta_Tarea4.f90"
DIR_EJECUTABLE_4="$DIR/Scripts/RungeKuta_Tarea4.out"

N_JOBS=$(( $(nproc) ))
# ─── Preparación ─────────────────────────────────────────────────────────────
T_PREP=$(date +%s%3N)
mkdir -p "$DIR_DATOS_OUT" "$DIR_DATOS_OUT_2" "$DIR_GIFS_SISTEMA" "$DIR_GIFS_SISTEMA_2" "$DIR_DATOS_OUT_3" "$DIR_GIFS_SISTEMA_3" "$DIR_DATOS_OUT_4" "$DIR_GIFS_SISTEMA_4"
rm -f "$DIR_DATOS_OUT"/*.dat "$DIR_DATOS_OUT_2"/*.dat "$DIR_DATOS_OUT_3"/*.dat "$DIR_DATOS_OUT_4"/*.dat
rm -f "$DIR_GIFS_SISTEMA"/*.mp4 "$DIR_GIFS_SISTEMA_2"/*.mp4 "$DIR_GIFS_SISTEMA"/*.png "$DIR_GIFS_SISTEMA_2"/*.png "$DIR_GIFS_SISTEMA_3"/*.mp4 "$DIR_GIFS_SISTEMA_3"/*.png "$DIR_GIFS_SISTEMA_4"/*.mp4 "$DIR_GIFS_SISTEMA_4"/*.png
fase "Preparación de directorios" "$T_PREP"

# ─── Funciones auxiliares ─────────────────────────────────────────────────────
limit_jobs() {
    while [ "$(jobs -rp | wc -l)" -ge "$N_JOBS" ]; do
        wait -n
    done
}

render_Luna() {
    local data_dir="$1" out_dir="$2"
    local archivos=("RungeKutta_orbita.dat")
    local archivos_Luna=("RungeKutta_orbita_Luna.dat")
    cd "$data_dir"
    for i in "${!archivos[@]}"; do
        local video_out="$out_dir/Luna_${archivos[$i]%.dat}.mp4"
        gnuplot -e "archivo_entrada='${archivos[$i]}'; archivo_entrada_Luna='${archivos_Luna[$i]}'; video_out='$video_out'; x_label='Posición (x)'" "$DIR/Animation/Animacion_Luna.plt" &
    done
}

render_Hamiltoniano() {
    local data_dir="$1" out_dir="$2"
    local archivos=("RungeKutta_energia.dat")
    cd "$data_dir"
    for i in "${!archivos[@]}"; do
        local video_out="$out_dir/Hamiltoniano_${archivos[$i]%.dat}.png"
        gnuplot -e "archivo_entrada='${archivos[$i]}'; video_out='$video_out'" "$DIR/Animation/Hamiltoniano.plt" &
    done
}

render_Sin_Luna() {
    local data_dir="$1" out_dir="$2"
    local archivos=("RungeKutta_orbita.dat")
    cd "$data_dir"
    for i in "${!archivos[@]}"; do
        local video_out="$out_dir/Sin_Luna_${archivos[$i]%.dat}.mp4"
        gnuplot -e "archivo_entrada='${archivos[$i]}'; video_out='$video_out'; x_label='Posición (x)'" "$DIR/Animation/Animacion.plt" &
    done
}

# ─── Compilación en paralelo ─────────────────────────────────────────────────
T_COMP=$(date +%s%3N)
echo "[1/4] Compilando..."

gfortran -O3 -ffree-line-length-none -march=native -ffast-math "$DIR_SCRIPT"   -o "$DIR_EJECUTABLE"  &
pid_c1=$!
gfortran -O3 -ffree-line-length-none -march=native -ffast-math "$DIR_SCRIPT_2" -o "$DIR_EJECUTABLE_2" &
pid_c2=$!
gfortran -O3 -ffree-line-length-none -march=native -ffast-math "$DIR_SCRIPT_3" -o "$DIR_EJECUTABLE_3" &
pid_c3=$!
gfortran -O3 -ffree-line-length-none -march=native -ffast-math "$DIR_SCRIPT_4" -o "$DIR_EJECUTABLE_4" &
pid_c4=$!

wait "$pid_c1" || { echo "Error compilando Auto.f90"; exit 1; }
wait "$pid_c2" || { echo "Error compilando Func.f90"; exit 1; }
wait "$pid_c3" || { echo "Error compilando Tarea3.f90"; exit 1; }
wait "$pid_c4" || { echo "Error compilando Tarea4.f90"; exit 1; }
fase "Compilación (ambos .f90 en paralelo)" "$T_COMP"

# ─── Simulaciones en paralelo ─────────────────────────────────────────────────
T_SIM=$(date +%s%3N)
echo "[2/4] Ejecutando simulaciones..."

"$DIR_EJECUTABLE"  &
pid_s1=$!
"$DIR_EJECUTABLE_2" &
pid_s2=$!
"$DIR_EJECUTABLE_3" &
pid_s3=$!
"$DIR_EJECUTABLE_4" &
pid_s4=$!

wait "$pid_s1" || { echo "Error en simulación Auto"; exit 1; }
wait "$pid_s2" || { echo "Error en simulación Func"; exit 1; }
wait "$pid_s3" || { echo "Error en simulación Tarea3"; exit 1; }
wait "$pid_s4" || { echo "Error en simulación Tarea4"; exit 1; }
fase "Simulaciones Fortran (ambas en paralelo)" "$T_SIM"

# ─── Renderizado en paralelo ──────────────────────────────────────────────────
T_RENDER=$(date +%s%3N)
echo "[3/4] Renderizando vídeos (N_JOBS=$N_JOBS)..."

render_Luna "$DIR_DATOS_OUT" "$DIR_GIFS_SISTEMA" &
render_Luna "$DIR_DATOS_OUT_2" "$DIR_GIFS_SISTEMA_2" &
render_Luna "$DIR_DATOS_OUT_3" "$DIR_GIFS_SISTEMA_3" &
render_Luna "$DIR_DATOS_OUT_4" "$DIR_GIFS_SISTEMA_4" &


render_Sin_Luna "$DIR_DATOS_OUT" "$DIR_GIFS_SISTEMA" &
render_Sin_Luna "$DIR_DATOS_OUT_2" "$DIR_GIFS_SISTEMA_2" &
render_Sin_Luna "$DIR_DATOS_OUT_3" "$DIR_GIFS_SISTEMA_3" &
render_Sin_Luna "$DIR_DATOS_OUT_4" "$DIR_GIFS_SISTEMA_4" &

#render_Hamiltoniano "$DIR_DATOS_OUT" "$DIR_GIFS_SISTEMA" &
#render_Hamiltoniano "$DIR_DATOS_OUT_2" "$DIR_GIFS_SISTEMA_2" &
#render_Hamiltoniano "$DIR_DATOS_OUT_3" "$DIR_GIFS_SISTEMA_3" &
render_Hamiltoniano "$DIR_DATOS_OUT_4" "$DIR_GIFS_SISTEMA_4" &

wait
fase "Renderizado de vídeos ($(( 3+1+3+1 )) MP4)" "$T_RENDER"

# ─── Resumen final ────────────────────────────────────────────────────────────
T_TOTAL_FIN=$(date +%s%3N)
echo ""
echo "====================================="
echo " RESUMEN DE TIEMPOS"
echo "====================================="
echo "  Tiempo total: $(fmt_tiempo $(( T_TOTAL_FIN - T_TOTAL_INICIO )))"
echo "====================================="
echo "¡Proceso finalizado con éxito!"