#!/bin/bash

folder=/home/enzo/Downloads/sis_operativos

while true; do

	rm -r /home/enzo/Downloads/sis_operativos/copia_de_seguridad_*
	mkdir /home/enzo/Downloads/sis_operativos/copia_de_seguridad_$(date '+%d-%m-%Y-%H:%M')
	tar --force-local -czvf copia_de_seguridad_$(date '+%d-%m-%Y-%H:%M')/copia-de-sis_operativos.tar.gz $folder
	sleep 60;

done


exit 0
