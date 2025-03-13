#!/bin/bash

# Obtenir la ruta absoluta del directori del script
script_dir="$(dirname "$(realpath "$0")")"

# Definir el script que es vol programar al cron
script="$script_dir/cerrar_automatico.sh"

# Definir la línia de cron que s'afegirà
cron_job="59 23 * * * /bin/bash $script" 

# Comprovar si ja existeix la tasca per no duplicar-la
(crontab -l 2>/dev/null | grep -v "$script"; echo "$cron_job") | crontab -

echo "✅ Tasca programada correctament! Pots comprovar-ho amb: crontab -l"

