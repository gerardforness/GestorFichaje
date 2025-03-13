#!/bin/bash
#Gerard Fornés, Pol González y Jordi Ros

lista_fichaje="lista_fichaje.txt"

while [ true ]; do # BUCLE PERMANENTE
	echo " "
	echo -n "Introduzca ID usuario o salir(0): " # SOLICITAMOS AL USUARIO QUE ELIGA ENTRE INTRODUCIR ID O SALIR
	read id_usuario
	if [ $id_usuario -eq 0 ]; then # SI INTRODUCE UN 0 SALE DEL BUCLE
		break
	else
		nombre=$(awk -F: -v id=$id_usuario '$1==id {print $2}' lista_usuarios.txt) # BUSCAR NOMBRE DEL USUARIO EN EL REGISTRO DE FICHAJE
		if [ -n "$nombre" ]; then
			apellido=$(awk -F: -v id=$id_usuario '$1==id {print $3}' lista_usuarios.txt) # BUSCAR APELLIDO DEL USUARIO
			echo " "
			echo "Bienvenido/a $nombre $apellido"
			echo " "
			echo "+------------------------------------+"
			echo "| SELECCIONE OPCION                  |"
			estado_usuario=$(awk -F- -v id=$id_usuario '$1==id {print $2}' $lista_fichaje | tail -n 1) # BUSCAR ESTADO (FICHAJE DE ENTRADA/SALIDA) DEL USUARIO
			if [ -z "$estado_usuario" ] || [ "$estado_usuario" == "SALIDA" ]; then # SI EL ESTADO ACTUAL DEL USUARIO ES "SALIDA" PREGUNTA SI QUIERE FICHAR PARA SALIR
				echo "| 1. Fichar para ENTRAR              |"
			elif [ "$estado_usuario" == "ENTRADA" ]; then # SI EL ESTADO ACTUAL DEL USUARIO ES "ENTRADA" PREGUNTA SI QUIERE FICHAR PARA SALIR
				echo "| 1. Fichar para SALIR               |"
			fi
			echo "| 2. Cancelar                        |"
			echo "+------------------------------------+"
			echo -n ">"
			read opcion_menu
			case $opcion_menu in
				1) # PROCESO DE FICHAJE
					hora=`date +%X` # BUSCAR HORA
					fecha=`date +%x` # BUSCAR FECHA
					if [ -z "$estado_usuario" ] || [ "$estado_usuario" == "SALIDA" ]; then # SI EL ESTADO ACTUAL DEL USUARIO ES "SALIDA"
						echo $id_usuario"-ENTRADA-"$fecha"-"$hora >> $lista_fichaje # INTRODUZIR INFORMACION EN ARCHIVO DE FICHAJE
						echo " "
						echo "Fichado para ENTRAR a las $hora"
					elif [ "$estado_usuario" == "ENTRADA" ]; then # SI EL ESTADO ACTUAL DEL USUARIO ES "ENTRADA"
						echo $id_usuario"-SALIDA-"$fecha"-"$hora >> $lista_fichaje # INTRODUCIR INFORMACION EN ARCHIVO DE FICHAJE
						echo " "
						echo "Fichado para SALIR a las $hora"
					fi
					;;
				2) # CANCELAR PROCESO					
					echo " "
					echo "Proceso cancelado";;
				*) # SI EL VALOR INTRODUCIDO NO ES VALIDO
					echo " "
					echo "Valor no valido";;
			esac
		else
			echo " "
			echo "ERROR: Este usuario no existe"
		fi
	fi
done
echo " "
echo "Fin del programa"
