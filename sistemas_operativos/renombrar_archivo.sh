#!/bin/bash

variable=$(find . -name "*.txt")

for arch in ${variable[*]}
do
	name=$(echo $arch | cut -d/ -f2)
	cp $name backup_$name
done
#echo $carpeta
exit 0
