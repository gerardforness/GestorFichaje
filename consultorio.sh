#!/bin/bash
## Gerard Fornés, Pol González y Jordi Ros

lista_fichaje="lista_fichaje.txt"

sumar_horas_dia() {
	dia="$1"
	mes="$2"
	ano="$3"
	id="$4"
	fecha="$dia/$mes/$ano"
	hora_entrada=$(awk -F- -v id=$id -v fecha="$fecha" '$1==id && $2=="ENTRADA" && $3==fecha {print $4}' $lista_fichaje | tail -n 1)
	hora_salida=$(awk -F- -v id=$id -v fecha="$fecha" '$1==id && $2=="SALIDA" && $3==fecha {print $4}' $lista_fichaje | tail -n 1)
	segundo_entrada=$(date -d "$hora_entrada" +%s)
	segundo_salida=$(date -d "$hora_salida" +%s)
	segundo_dia=$((segundo_salida-segundo_entrada))
	echo $segundo_dia
}

while [ true ]; do
	echo -n "Introduzca ID usuario o Salir (0): "
	read id_usuario
	if [ $id_usuario -eq 0 ]; then
		echo "Fin del programa"
		break
	else
		nombre=$(awk -F: -v id=$id_usuario '$1==id {print $2}' lista_usuarios.txt)
		apellido=$(awk -F: -v id=$id_usuario '$1==id {print $3}' lista_usuarios.txt)
		if [ "$nombre" != "" ]; then
			while [ true ]; do
				echo "+----------------------------------+"
				echo "| SELECCIONE PARAMETRO DE BUSQUEDA |"
				echo "| 1. dia                           |"
				echo "| 2. mes                           |"
				echo "| 3. año                           |"
				echo "| 4. <atras                        |"
				echo "+----------------------------------+"
				echo -n ">"
				read op
				case $op in
					1)
						echo -n "dia: "
						read dia
						echo -n "mes: "
						read mes
						echo -n "año: "
						read ano
						segundo_dia=$(sumar_horas_dia $dia $mes $ano $id_usuario)
						echo " "
						echo -n "El usuario $nombre $apellido ha trabajado un total de "
						echo -n $(date -u -d @"$segundo_dia" +%H:%M:%S)
						echo " horas el dia $dia/$mes/$ano"
						echo " "
						;;
					2)
						echo -n "mes: "
						read mes
						echo -n "año: "
						read ano
						segundo_dia=0
						for i in `seq 1 31`; do
							if [ $i -lt 10 ]; then
								dia="0$i"
							else
								dia=$i
							fi
							segundo_dia=$(($segundo_dia+$(sumar_horas_dia $dia $mes $ano $id_usuario)))
						done
						echo " "
						echo -n "El usuario $nombre $apellido ha trabajado un total de "
						echo -n $(date -u -d @"$segundo_dia" +%H:%M:%S)
						echo " horas el mes $mes/$ano"
						echo " "
						;;
					3)
						echo -n "año: "
						read ano
						segundo_dia=0
						for i in `seq 1 12`; do
							for j in `seq 1 31`; do
								if [ $i -lt 10 ]; then
									mes="0$i"
								else
									mes=$i
								fi
								if [ $j -lt 10 ]; then
									dia="0$j"
								else
									dia=$j
								fi
								segundo_dia=$(($segundo_dia+$(sumar_horas_dia $dia $mes $ano $id_usuario)))
							done
						done
						echo " "
						echo -n "El usuario $nombre $apellido ha trabajado un total de "
						echo -n $(date -u -d @"$segundo_dia" +%H:%M:%S)
						echo " horas el año $ano"
						echo " "
						;;
					4)
						break;;
					*)
						echo "ERROR: valor invalido";;
				esac
			done
		else
			echo "ERROR: id no existe"
		fi
	fi
done
