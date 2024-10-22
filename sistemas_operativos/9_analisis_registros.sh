#!/bin/bash

#construyendo este script con ayuda de https://medium.com/winkhostinglatam/monitoreo-de-servidores-con-bash-scripts-y-php-b40f97a9ba2d

# Directorio de almacenamiento temporal
DIRTMP=/tmp

# uptime y load
uptime > $DIRTMP/uptime.log
#Este comando muestra el tiempo que lleva operando el servidor desde el último reinicio,
#cantidad de usuarios activos y la carga promedio de procesamiento de los últimos 1, 5 y 15 minutos.

# almacenamiento
df -h > $DIRTMP/storage.log

# uso de memoria
free -m > $DIRTMP/memoryusage.log

# top 10 cpu
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10 > $DIRTMP/top10cpu.log

#en la pagina profundizan mas, pero no entiendo por que borran con rm cuando estan creandolo
