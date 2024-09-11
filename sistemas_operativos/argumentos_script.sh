#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Por favor ingrese un nombre."
	exit 1
fi

echo $1
exit 0
