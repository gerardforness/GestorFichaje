#!/bin/bash


script_dir="$(dirname "$(realpath "$0")")"
fichero="$script_dir/lista_fichaje.txt"


fecha=$(date +%x)

while read line
do
	data_entrada=$(echo $line | awk -F- '{print $3}')
	if [ "$data_entrada" == "$fecha" ]
	then
		usuario=$(echo $line | awk -F- '{print $1}')
		estat=$(echo $line | awk -F- '{print $2}')
		if [ "$estat" == "ENTRADA" ]
		then
			te_sortida=0
			while read line
			do
				data_entrada2=$(echo $line | awk -F- '{print $3}')
				if [ "$data_entrada2" == "$fecha" ]
				then
					usuario2=$(echo $line | awk -F- '{print $1}')
					estat=$(echo $line | awk -F- '{print $2}')
					if [ "$estat" == "SALIDA" ] && [ "$usuario" == "$usuario2" ]
					then
						te_sortida=1
						break					
					fi
				fi
			done < $fichero
			if [ $te_sortida -eq 0 ]
			then
				echo $usuario"-SALIDA-"$fecha"-23:59:00" >> $fichero
			fi
		fi
	fi
done < $fichero

