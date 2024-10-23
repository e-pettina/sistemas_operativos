#!/bin/bash

if [ $# -ne 1 ]; then
    echo "debe ingresar un directorio como parametro"
    exit 1
fi

name_folder=$($1 | rev | cut -d/ -f 1 | rev)

mkdir copia_de_seguridad_$(date '+%Y-%m-%d')

tar -czvf copia_de_seguridad_$(date '+%Y-%m-%d')/copia-de-$name_folder.tar.gz $1

exit 0