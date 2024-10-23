#!/bin/bash

if [[ $# -ne 2 || ! $1 =~ ^[a-zA-Z0-9]+$ || ! $2 == /* ]]; then
	echo "debe ingresar un nombre de archivo a buscar como primer parametro y el path donde desea buscarlo como segundo parametro"
	exit 1
fi

resultados=$(find "$2" -type f -name "*$1*")

cantidad=$(printf "%s\n" "$resultados" | wc -l)

extensiones=()

peso=0

for archivos in $resultados; do
	peso=$((peso + $(stat -c%s "$archivos")))

	extension="${archivos##*.}"
	extensiones+=("$extension")
done

peso_kb=$(numfmt --to iec "$peso")

cantidad_repeticiones=$(printf "%s\n" "${extensiones[@]}" | sort | uniq -c | sort -nr)

mayor_repeticion=0

while read -r repeticion; do
	valor=$(echo "$repeticion" | cut -d " " -f 1)
	if (( valor > mayor_repeticion )); then
		mayor_repeticion=$valor
	fi
done <<< "$cantidad_repeticiones"

extensiones_mas_repetidas=()

while read -r repeticion; do
	valor=$(echo "$repeticion" | cut -d " " -f 1)
	if (( valor == mayor_repeticion )); then
		extension=$(echo "$repeticion" | cut -d " " -f 2)
		extensiones_mas_repetidas+=("$extension")
	fi
done <<< "$cantidad_repeticiones"

{
	echo "Cantidad de archivos encontrados: $cantidad"
	echo ""
	echo "Peso total de los archivos: $peso_kb ($peso bytes)"
	echo ""
	echo "Formato(s) más común(es): ${extensiones_mas_repetidas[*]}"
} > "$2/resultado.log"

exit 0
