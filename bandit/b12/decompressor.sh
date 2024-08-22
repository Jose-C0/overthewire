#!/bin/bash
name_decompressed=$(7z l content.gzip | grep "Name" -A 2 | tail -n 1 | awk 'NF{print $NF}')    # guardo el nombre del archivo que se encuentra dentro de content.gzip
7z x content.gzip > /dev/null 2>&1    # se extrae el archivo y se redirige STDERR, STDOUT a la carpeta /dev/null

while true; do
# bucle que finaliza cuando el archivo ya no pueda ser descomprimido
    7z l $name_decompressed > /dev/null 2>&1   

    if [ "$(echo $?)" == "0" ]; then
# Si el archivo puede ser descomprimido, se extrae el nombre del archivo dentro del archivo actualmente descomprimido.  Luego, se descomprime este archivo y se actualiza name_decompressed para referirse al nuevo archivo descomprimido.
        decompressed_next=$(7z l $name_decompressed | grep "Name" -A 2 | tail -n 1 | awk 'NF{print $NF}')
        7z x $name_decompressed > /dev/null 2>&1 && name_decompressed=$decompressed_next
    else
# Si el archivo no puede ser descomprimido, se muestra el contenido del archivo con cat, se eliminan todos los archivos que comienzan con "data" y se sale del script con un código de salida de 1.
        cat $name_decompressed; rm data* 2>/dev/null
        exit 1
    fi

done
