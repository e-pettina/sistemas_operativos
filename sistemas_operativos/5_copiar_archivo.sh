#!/bin/bash

variable=$(find . -name "*.log")

##echo $variable

mkdir $(pwd)/logs_backup
##mkdir /home/$(whoami)/logs_backup2

for arch in ${variable[*]}
do
	name=$(echo $arch | cut -d/ -f2)
	##cp $name /home/$(whoami)/logs_bakcup2/$name
	cp $(pwd)/logs_backup/$name
done

exit 0
