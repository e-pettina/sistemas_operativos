#!/bin/bash

device=/dev/sda2

espacio=$(df -h | grep $device | expand | tr -s " " | cut -d " " -f5 | cut -d "%" -f1)

if [ $espacio -ge 90 ]; then
	mensaje=$(echo "El espacio de " $device " en " $(hostname) "se encuentra al" $espacio"%")
	asunto=$(echo "Advertencia de poco espacio libre en " $device)
	echo $mensaje | mail -s "$asunto" "enzopettina.0@gmail.com"
fi
