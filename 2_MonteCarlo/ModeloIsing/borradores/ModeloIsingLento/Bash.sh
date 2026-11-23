DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR_DATOS_OUT="$DIR/Datos"


# Directorios temporales para los frames (idealmente en RAM si tienes memoria de sobra, usando /dev/shm/)
mkdir -p "$DIR_GIFS_SISTEMA/tmp_frames" 

cd "$DIR_DATOS_OUT" || exit

archivo_entrada_Sist=($(ls datos*.dat))

archivos_string_sist="${archivo_entrada_Sist[*]}"    

awk -v N=50 '                                                                                         23:30 
NF == 2500 {
    for(i=1; i<=N; i++) {
        for(j=1; j<=N; j++) {
            printf "%s ", $(j + (i-1)*N)
        }
        print ""
    }
    print "\n"
}' Resultados.txt > $archivo_string_sist"50x50".txt



echo "Generando  ..."

do T in $(cat Temperaturas.dat); do
    echo "Generando frames para T=$T..."
    gnuplot -e "dir_frames='$DIR_GIFS_SISTEMA/tmp_frames/'; archivo_entrada='$archivos_string_sist[$i]'; temperatura=$T" Animacion.plt 2>/dev/null &
done




wait
echo "Frames generados. Ensamblando GIFs con FFmpeg..."

ffmpeg -framerate 20 -i tmp_frames/frame_%04d.png -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 18 simulacion_ising2.mp4

wait

# Limpieza de temporales
rm -rf "$DIR_GIFS_SISTEMA"/tmp_*

echo "¡Proceso terminado y optimizado!"



