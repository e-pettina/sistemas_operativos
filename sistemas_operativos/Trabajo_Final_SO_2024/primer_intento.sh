#!/bin/bash

if [[ $# -ne 2 || ! $1 =~ ^[a-zA-Z0-9]+$ || ! $2 == /* ]]; then
	echo "debe ingresar un nombre de archivo a buscar como primer parametro y el path donde desea buscarlo como segundo parametro"
	exit 1
fi
# para no olvidarme: ^ indica el inicio del conjunto a analizar,
# =~ sirve para comparar cadenas mientras que -ne es para comparar numeros
# +$ esta para indicar que busque al menos 1 de lo encerrado entre corchetes (el +) y para terminar el conjunto a analizar (el $)
# se aplica corchetes dobles para poder usar || que seria similar a &&, solo que este significa OR IF, en lugar de AND IF
# el ! antes del $1 invierte lo buscado, es decir en lugar de activarse al cumplirse, se activa al no cumplirse la condicion
# y el /* sirve debido a que de por si / ya es un path absoluto en linux, donde se contienen todos los archivos y directorios del so


resultados=$(find $2 -type f -name "*$1*")
#### resultados: almacena los archivos que contengan el string ingresado en $1 que se encuentren en el path ingresado en $2
# los asteriscos permitian buscar el string sin importar donde este en el nombre del archivo
# el type nos permitia, acompañado de f, limitar la busqueda a solo archivos normales, no incluiria directorios por ejemplo


cantidad=$(printf "%s\n" $resultados | wc -l)
#### cantidad: de archivos encontrados con ese parametro
# printf funciona como echo pero permite mas opciones, %s tomaria los string y el \n forzaría un salto de linea entre cada uno
# de ese modo se evita que al usar wc -l se cuente como solo 1, como sucedia con el echo


extensiones=()
# arreglo para guardar todas

peso=0

for archivos in $resultados
do
	peso=$((peso + $(stat -c%s $archivos)))

	extension="${archivos##*.}"
	extensiones+="($extension)"
done

peso_kb=$(numfmt --to iec $peso)
#### extension: para separar cada extension de cada archivo
#### extensiones: almacena todas las extensiones que fueron separadas
# el ##*. es para tomar la parte mas larga(##) de cualquier cosa(*) antes del punto (.)
# si en lugar del * se pusiera una palabra o secuencia de caracteres, buscaria la parte mas larga que coincida con ese patron
#### peso: en bytes de los archivos encontrados
#### peso_kb: en kilobytes
# stat -c%s ya muestra el peso de los archivos, pero no el total, por eso iteramos para sumarlos uno a uno
# numfmt convierte numeros a string entendible por humanos
# --to sirve para auto escalar a unidades
# iec ingresa un caracter de referencia para la unidad

cantidad_repeticiones=$(printf "%s\n" "${extensiones[@]}" | sort | uniq -c | sort -nr)
# con head tomabamos las primeras lineas, en este caso la primera, esto lo borre al final
# uniq -c para mostrar cuantas veces aparece cada extension y mostrar el numero junto a cada una
# sort los ordena y agrupa por nombre, sort -nr los ordena pero numericamente y de mayor a menor
# el @ sirve como el * pero para cada dato del arreglo

mayor_repeticion=0

for repeticion in {"$cantidad_repeticiones[@]"}
do
	valor=$(echo "$repeticion" | cut -d " " -f 1)
	if (( valor -gt  mayor_repeticion )); then
		mayor_repeticion=$valor
	fi
done
# usamos cut para extraer el primer campo, donde estaria ubicada la cantidad de repeticiones de la extension
# este for intenta capturar el valor mas alto, o mayor, que se haya encontrado

extensiones_mas_repetidas=()

for repeticion in {"$cantidad_repeticiones[@]"}
do
	valor=$(echo "$repeticion" | cut -d " " -f 1)
	if (( valor -eq mayor_repeticion )); then
		extension=$(echo "$repeticion" | cut -d " " -f 2)
		extensiones_mas_repetidas+=("$extension")
	fi
done
# este for utiliza el valor mas alto almacenado en mayor_repeticion en el anterior for
# para encontrar todas las expensiones que tengan ese valor en comun
# es decir, estoy intentanto captar no solo un resultado con el numero mas alto, sino todos aquellos que compartan ese numero mas alto
# aca el cut toma el segundo campo, donde estaria el nombre o abreviatura de la extension y ya la almacena en la variable final

{
	echo "Cantidad de archivos encontrados: " $cantidad
	echo ""
	echo "Peso total de los archivos: " $peso_kb "B (" $peso " bytes)"
	echo ""
	echo "Formato(s) más común(es): " $extensiones_mas_repetidas
} > "$2/resultado.log"
# esto pone el contenido en el archivo, dejamos el path ingresado como ubicacion donde crear el archivo
# el uso de > sobreescribiria el archivo, pero en este caso lo crea por no existir

exit 0





# sumo a la entrega los enlaces consultados para armarlo
#
# para la condicion del if:
#
# https://es.stackoverflow.com/questions/509575/concatenar-dos-condiciones-en-bash
# https://tldp.org/LDP/abs/html/testconstructs.html
# https://atareao.es/tutorial/scripts-en-bash/condicionales-en-bash/
# https://es.stackoverflow.com/questions/50041/c%C3%B3mo-se-comparan-cadenas-en-bash
# https://stackoverflow.com/questions/4510640/what-is-the-purpose-of-in-a-shell-command
#
# intento fallido: incluir simbolos como parte de la posibilidad del string... intentando usarlo así:
# ! $1 =~ ^[a-zA-Z0-9!#$%&'()+,-.;=@[]^_`{}~]+$
# daba diferentes errores al ejecutar la condicion de ese modo.


# para el conteo de archivos, extensiones y su peso:
# https://lpic1.wordpress.com/2012/02/22/comandos-para-resumir-ficheros-cut-y-wc/
# https://unix.stackexchange.com/questions/346902/need-to-convert-bytes-to-gb-mb-kb-in-normal-decimal-format
# https://www.man7.org/linux/man-pages/man1/numfmt.1.html
# https://es.stackoverflow.com/questions/455615/que-significa-dentro-del-mecanismo-parameter-expansion-en-bash
# https://unix.stackexchange.com/questions/347791/what-does-operator-in-front-of-a-variable-do-in-variable-expansion (al final no lo use)
# https://es.stackoverflow.com/questions/447327/cu%C3%A1l-es-la-diferencia-entre-usar-o-en-una-comparaci%C3%B3n-de-texto-en-bash-c

# y tambien busque la diferencia entre * y @ pero perdi la fuente, decia algo de que el * separa por espacios, lo cual
# podia llegar a generar algun error si los nombres de archivos tenian espacios como en windows, mientras que el @ mantiene los epsacios
