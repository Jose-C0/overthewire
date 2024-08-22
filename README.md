### - Bandit Level 1 → Level 2  

LEVEL GOAL: The password for the next level is stored in a file called - located in the home directory

**Solución:** Si uso `cat -` la consola se queda congelada.  

Comando que funcionan para leer guiones:  

| Comandos | Descripción  |
| ------------- | ------------- |
| `cat ./- ` | DIRECTORIO - ACTUAL /- |  
| `cat /home/bandit1/- ` | Ruta absoluta |
| `cat ~/-` | ~/ es un atajo para inidicar nombre de usuario |
| `cat ~/* ` | El * lista todos los elemntos del directorio |
| `cat $(pwd)/- ` | `$` es el output de un comando a nivel de sistema. `pwd` indica la ruta actual |

### - - Bandit Level 2 → Level 3  

LEVEL GOAL: The password for the next level is stored in a file called spaces in this filename located in the home directory

**Solución:** 

1. Escribe sapce y luego usa la tabulacion para que complete el nombre
2. Usa el comodín * `cat spaces*`

### - Bandit Level 3 → Level 4     

LEVEL GOAL: The password for the next level is stored in a hidden file in the inhere directory.

**Solución:**  

Comandos que funionan: 

1. `ls -al inhere/`

salida ->> /...Hiding-From-You

`cat inhere/...Hiding-From-You `  
`cat inhere/.*`  

2. `find . -type f -printf "%f\t%p\t%u\t%g\t%m\n" | column -t` 

->> EXPLICACIÓN:  

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| `-type f`    | Busca todos los archivos |
| `\t`         | Tabular |
| `\n`         | Salto de linea |
| `%f`         | Archivos |
| `%p`         | Ruta absoluta  |
| `%u`         | Usuario propietario  |
| `%g`         | Grupo asignado |
| `%m`         | Permiso asignado de manera númerica (modo) |
| `column -t`  | Formatea la salida en tabs |  

3. `find . -name ...Hiding-From-You | xargs cat`  

->> `xargs`  se usa para ejecutar un comando sobre la salida de un comando de forma paralela. 


### - Bandit Level 4 → Level 5     

LEVEL GOAL: The password for the next level is stored in the only human-readable file in the inhere directory. Tip: if your terminal is messed up, try the “reset” command.

**Solución:**  

1. `file inhere/*`  

2. `find . -name - file* | xargs file`  

```sh
./inhere/-file00: data
./inhere/-file03: data
./inhere/-file08: data
./inhere/-file02: data
./inhere/-file04: data
./inhere/-file01: data
./inhere/-file07: ASCII text
./inhere/-file06: data
./inhere/-file05: data
./inhere/-file09: data
```  

Se elige el ./inhere/-file07 porque es el unico legible por el humano (ASCII text). Luego ejecuto el siguiente comando:  

```sh
cat $(find . -name -file07)  
           o
cat $(pwd)/inhere/-file07  
```  

EXPLICACION: El comando file es una utilidad que realiza una serie de pruebas (test) para determinar el tipo y formato de un archivo. Más precisamente las pruebas son tres, y la primera que permita alcanzar un resultado hace que el análisis finalice. (Sistema de archivos, Números mágicos, Prueba de sintaxis.)

### - Bandit Level 5 → Level 6     

LEVEL GOAL: The password for the next level is stored in a file somewhere under the inhere directory and has all of the following properties:

> human-readable  
> 1033 bytes in sie  
> not executable  

**Solución:**  

Comando: `find  inhere/ -type f -readable ! -executable -size 1033c | xargs cat`  

->> Explicación:  

| Parametro       | Descripción                    |
| --------------- | ------------------------------ |
| `-type f`       | Busca todos los archivos |
| `-readable`     | Coincide con los archivos que puede leer el usuario actual. |
| `! -executable` | Coincide con archivos que son ejecutables y directorios que son buscables (en el sentido de resolución de nombres de archivo) por el usuario actual. El signo de exclamación ! es negación. |
| `-size 1033c`   | Tamaño del archivo. La c al final indica que esta expresado en bytes. |

### - Bandit Level 6 → Level 7     

Level Goal:
The password for the next level is stored somewhere on the server and has all of the following properties:

> owned by user bandit7  
> owned by group bandit6  
> 33 bytes in size  

S :>>

Comando: `find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs cat`  

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| 2>           | es STDERR.  |
| /dev/null    | Los datos enviados en esta ruta son descartados. |
| 33c          | 33 bytes. |


### - Bandit Level 7 → Level 8     


LEVEL GOAL: The password for the next level is stored in the file data.txt next to the word millionth

S :>>
Comandos:  

1. `grep "millionth" data.txt`   (El mas optimo)  
2. `cat data.txt | grep "millionth"`  (Usa dos comando, es el menos optimo)  
3. `awk "/millionth/" data.txt`  

### - Bandit Level 8 → Level 9     

LEVEL GOAL: The password for the next level is stored in the file data.txt and is the only line of text that occurs only once

S :>>

Comandos:  
1. `cat data.txt | sort | unq -u `  
2. `sort data.txt | uniq -u `  

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| `uniq -u`    | Imprime las lineas que son unicas. Si no ordenamos la cadena unique no distingue bien entre las lineas que son diferentes. |

### - Bandit Level 9 → Level 10    

Level Goal: The password for the next level is stored in the file data.txt in one of the few human-readable strings, preceded by several ‘=’ characters.

S :>>
 
Comandos:
`strings data.txt | grep "=="`

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| `strings`    | El comando strings de Linux se utiliza para devolver los caracteres de cadena a los archivos. Se centra principalmente en determinar el contenido y extraer texto de los archivos binarios. |

### - Bandit Level 10 → Level 11   

LEVEL GOAL: The password for the next level is stored in the file data.txt, which contains base64 encoded data  

S :>>
Al ejecutar `cat data.txt` la salida es así:  

```sh
bandit10@bandit:~$ cat data.txtLEVEL GOAL: The password for the next level is stored in the file data.txt, which contains base64 encoded data
VGhlIHBhc3N3b3JkIGlzIGR0UjE3M2ZaS2IwUlJzREZTR3NnMlJXbnBOVmozcVJyCg==
```  

Comando:  

1. `cat data.txt | base64 -d`  

`base64 -d`   ->> Para decodificar en base 64 se usa el parametro -d  

### - Bandit Level 11 → Level 12   


LEVEL GOAL: The password for the next level is stored in the file data.txt, where all lowercase (a-z) and uppercase (A-Z) letters have been rotated by 13 positions

S :>> 
`cat data.txt | tr '[G-ZA-Fg-za-f]' '[T-ZA-St-za-s]' | awk 'NF{print $NF}'`
  
EXPLICACIÓN: `tr` no es más que una abreviación de translate.  

### - Bandit Level 12 → Level 13   

LEVEL GOAL: The password for the next level is stored in the file data.txt, which is a hexdump of a file that has been repeatedly compressed. For this level it may be useful to create a directory under /tmp in which you can work. Use mkdir with a hard to guess directory name. Or better, use the command “mktemp -d”. Then copy the datafile using cp, and rename it using mv (read the manpages!)

S :>>

`cat data.txt`  

Luego copiar la salida de `cat data.txt` en mi equipo. Le dejo el nombre content.hex porque es un hexdump.  

`xdd -r content.hex > content`    ->> Revierte el archivo hexdump y lo redirijo a content.  

`file content`    ->> Determina el tipo de archivo de archivo (en este caso es un archivo comrimido gzip).  

`mv content content.gzip`    ->> agrego la extensión que le corresponde a content.  

`7z l content.gzip`    ->> para listar el contenido de un archivo comprimido.  

`7z x content.gzip`    ->>  el parametro x es par descomprimir el archivo  
	
Como el archivo fue comprimido multiples veces utilizamos este script para no hacer la descompresión de manera manual:  

```sh
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

```

### - Bandit Level 13 → Level 14   


LEVEL GOAL: The password for the next level is stored in /etc/bandit_pass/bandit14 and can only be read by user bandit14. For this level, you don’t get the next password, but you get a private SSH key that can be used to log into the next level. Note: localhost is a hostname that refers to the machine you are working on

S :>>

```sh
bandit13@bandit:~$ ls  # Al entrar en bandit13 si ejecuto ls obtengo: 
sshkey.private
bandit13@bandit:~$ cat sshkey.private 
```  

Luego copio el resultado del comando anterior. La salida es una clave privada RSA.  

En mi máquina, guardo la sshkey.private. En mi caso guardo la clave privada en el repositorio:  

`~/overthewire/bandit/.ssh_pass/id_rsa_bandit14`    ->> Aquí copio el ssh key rsa privado que encontré en bandit13.

Para entrar en bandit14 tengo dos métodos:  

1. Primer método.  

`ssh -p 2220 -i ~/overthewire/bandit/.ssh_pass/id_rsa_bandit14 bandit14@bandit.labs.overthewire.org`  

EXPLICACION:  

-i    ->> esta parametro es para que el servidor ssh busque el IdentityFile, para indicar en que ruta se encuentra la private key.

2. Segundo método.  

Corro el comando: nano ~/.ssh/config

Luego pego lo siguiente:  

> Host bandit14 
>   Hostname bandit.labs.overthewire.org 
>   user bandit14
>   port 2220
>   IdentityFile ~/overthewire/bandit14/.ssh/id_rsa  

Después de guardar y cerrar el editor del texto, ejecuto el siguiente comando:  

`ssh bandit14 `

LISTO !!!

```sh
bandit14@bandit:~$ cat /etc/bandit_pass/bandit14
Password :)
``` 

### - Bandit Level 14 → Level 15   

LEVEL GOAL: The password for the next level can be retrieved by submitting the password of the current level to port 30000 on localhost.

S :>>
`echo "" > /dev/tcp/127.0.0.1/30123`    ->> verificar si el puerto 30000 esta abierto
`echo $?`    ->> estatus de la salida del ultimo comando

1. `echo "PASSWORD de bandit14 :)" | nc localhost 30000`  

EXPLICACION:  

`nc` - es una herramienta de línea de comandos que se utiliza para leer y escribir datos a través de conexiones de red utilizando el protocolo TCP o UDP.  

Nota:  
Para saber si un puerto esta cerrado o abierto -->
`bash -c "echo '' > /dev/tcp/127.0.0.1/30000" 2>/dev/null &&  echo "[*] Puerto abierto" || echo "[*] Puerto cerrado"`  

### - Bandit Level 15 → Level 16   

LEVEL GOAL: The password for the next level can be retrieved by submitting the password of the current level to port 30001 on localhost using SSL/TLS encryption.  

Helpful note: Getting “DONE”, “RENEGOTIATING” or “KEYUPDATE”? Read the “CONNECTED COMMANDS” section in the manpage.  

S :>>  

1. `openssl s_client -connect localhost:30001  `

Pegar el PASSWORD de bandit14 y LISTO!!! :)  

### - Bandit Level 16 → Level 17   

LEVEL GOAL: The credentials for the next level can be retrieved by submitting the password of the current level to a port on localhost in the range 31000 to 32000. First find out which of these ports have a server listening on them. Then find out which of those speak SSL/TLS and which don’t. There is only 1 server that will give the next credentials, the others will simply send back to you whatever you send to it.  

Solución:    

`nmap --open -T5 -v -n -p31000-32000 127.0.0.1`  

EXPLICACION:  

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| `--open`     | Nmap que solo muestre los puertos abiertos en la salida. |
| `-T5`        | Esto establece la plantilla de tiempo en la velocidad más alta (5). Acelera  significativamente el escaneo, pero puede aumentar la probabilidad de perder algunas respuestas o ser detectado por sistemas de detección de intrusiones. Las plantillas de tiempo van desde 0 (paranoico) hasta 5 (insano). Nota: Solo usar en entornos controlados.
| `-v`         |  verbose  |
| `-n`         | Esta opción evita que Nmap realice la resolución DNS. Acelera el escaneo al no  intentar resolver direcciones IP a nombres de host. |  
 
Para finalizar, envio la contraseña de bandit16 al localhost en el puerto que este abierto con SSL/TLS.  
 
1. `echo "PASSWORD de bandit16 :)" | openssl s_client -connect localhost:31790 -ign_eof`

2. `openssl s_client -connect localhost:31790 -ign_eof`  

Luego pegar la PASSWORD de bandit16  

EXPLICACION:  
 
| Parametro    | Descripción                    |
| ------------ | ------------------------------ |
| `-ign_eof`   | La opción -ign_eof garantiza que la conexión no finalice antes de tiempo. |  

Guardo la clave RSA privada en mi repositorio ~/overthewire/bandit/.ssh_pass/id_rsa_bandit17  

Para iniciar sesion en bandit17: 

`ssh -i id_rsa_bandit17 -p 2220 bandit17@bandit.labs.overthewire.org`  

### - Bandit Level 17 → Level 18   

LEVEL GOAL:  There are 2 files in the homedirectory: passwords.old and passwords.new. The password for the next level is in passwords.new and is the only line that has been changed between passwords.old and passwords.new  

NOTE: if you have solved this level and see ‘Byebye!’ when trying to log into bandit18, this is related to the next level, bandit19  

S :>>

`diff /home/bandit17/passwords.old /home/bandit17/passwords.new`
 
### - Bandit Level 18 → Level 19   

LEVEL GOAL: The password for the next level is stored in a file readme in the homedirectory. Unfortunately, someone has modified .bashrc to log you out when you log in with SSH.  

S :>>  

```sh
ssh -p 2220 bandit18@bandit.labs.overthewire.org "bash --norc"
ls
cat readme
```  

EXPLICACIÓN:  

| Parametro     | Descripción                    |
| ------------- | ------------------------------ |
| `bash --norc` | permite iniciar una sesión de shell sin la influencia de la configuración personalizada o los alias definidos en .bashrc. |  


### - Bandit Level 19 → Level 20   

LEVEL GOAL: To gain access to the next level, you should use the setuid binary in the homedirectory. Execute it without arguments to find out how to use it. The password for this level can be found in the usual place (/etc/bandit_pass), after you have used the setuid binary.  

S :>>  

`./bandit20-do cat /etc/bandit_pass/bandit20`  

### - Bandit Level 20 → Level 21   

LEVEL GOAL: There is a setuid binary in the homedirectory that does the following: it makes a connection to localhost on the port you specify as a commandline argument. It then reads a line of text from the connection and compares it to the password in the previous level (bandit20). If the password is correct, it will transmit the password for the next level (bandit21).  

NOTE: Try connecting to your own network daemon to see if it works as you think  

S :>>  

1. En una terminal ejecutar: 
`nc -nlvp 6020`

EXPLICACION:

| Parametro    | Descripción                        |
| ------------ | ------------------------------ |
| `-n`         | No realiza la resolución de nombres de host DNS. y evitar problemas de DNS. |
| `-l`         | Indica que nc debe funcionar en modo "escucha". Esto significa que el programa estará a la espera de conexiones entrantes en lugar de iniciar una conexión a un host remoto. |
| `-v`         | verbose. |
| `-p`         | Especifica el puerto en el que nc escuchará las conexiones entrantes. |  

2. En otra terminal:
`./suconnect 6020`  

Luego pegar PASSWORD bandit20 :) en la terminal donde ejecutamos `nc -nlvp 6020`  


### - Bandit Level 21 → Level 22   


LEVEL GOAL: A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.  

S :>>
```sh
ls -l /etc/cron.d  
cat /etc/cron.d/cronjob_bandit22  
cat /usr/bin/cronjob_bandit22.sh  
ls -al /usr/bin/cronjob_bandit22.sh  
cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv  
```  

### - Bandit Level 22 → Level 23   

LEVEL GOAL: A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.  

NOTE: Looking at shell scripts written by other people is a very useful skill. The script for this level is intentionally made easy to read. If you are having problems understanding what it does, try executing it to see the debug information it prints.   

S :>>

```sh
ls -l /etc/cron.d  
cat /etc/cron.d/cronjob_bandit23  
cat /usr/bin/cronjob_bandit23.sh  
echo I am user bandit23 | md5sum | cut -d ' ' -f 1  
cat /tmp/8ca319486bfbbc3663ea0fbe81326349  
```  

### - Bandit Level 23 → Level 24   

LEVEL GOAL: A program is running automatically at regular intervals from cron, the time-based job scheduler. Look in /etc/cron.d/ for the configuration and see what command is being executed.  

NOTE: This level requires you to create your own first shell-script. This is a very big step and you should be proud of yourself when you beat this level!  

NOTE 2: Keep in mind that your shell script is removed once executed, so you may want to keep a copy around…  

S :>>  

```sh
cat /etc/cron.d/cronjob_bandit24
cat /usr/bin/cronjob_bandit24.sh
mkdir /tmp/bandit
cd !$

touch script.sh && echo '#!/bin/bash
cat /etc/bandit_pass/bandit24 > /tmp/bandit/pass' > script.sh # ->> es para redirigir la contraseña a /tmp/bandit

chmod 777 -R /tmp/bandit

cp script.sh /var/spool/bandit24/foo/script.sh

watch -n 1 ls -la -->> para ejecutar el comando ls -la cada segundo
	o
ls -al

cat /tmp/bandit/pass
```  

LISTO !!  

### - Bandit Level 24 → Level 25   

LEVEL GOAL: A daemon is listening on port 30002 and will give you the password for bandit25 if given the password for bandit24 and a secret numeric 4-digit pincode. There is no way to retrieve the pincode except by going through all of the 10000 combinations, called brute-forcing.  

You do not need to create new connections each time.  

S :>>  

- Generar toda la combinatoria  
```sh
mktemp -d
cd /tmp/ID-ARCHIVO-GENERADO
touch script.sh
cat /etc/bandit_pass/$(whoami)  ->> PASSWORD bandit24
echo '#!/bin/bash' > script.sh && cat /etc/bandit_pass/$(whoami) 1>> script.sh
chmod +x script.sh
nano script.sh	
```  

El script deberia verse así:  

```script.sh         
#!/bin/bash
for i in {0000..9999}; do
    echo  "PASSWORD-BANDIT24 $i"
done
```  

Luego ejecutar el siguiente comando para tener las claves en un archivo:  

```sh
./script.sh > dictionary.txt
cat dictionary.txt | nc localhost 30002 | grep -v -E "Wrong|Please"
```  

### - Bandit Level 25 → Level 26   

LEVEL GOAL: Logging in to bandit26 from bandit25 should be fairly easy… The shell for user bandit26 is not /bin/bash, but something else. Find out what it is, how it works and how to break out of it.  

NOTE: if you’re a Windows user and typically use Powershell to ssh into bandit: Powershell is known to cause issues with the intended solution to this level. You should use command prompt instead.  

S :>>
```sh
cat /etc/passwd | grep bandit26
cat /usr/bin/showtext 

ssh -p 2220 -i bandit26.sshkey bandit26@localhost
```  

EXPLICACION `cat /usr/bin/showtext`: 

'showtext' abre un archivo llamado 'text.txt' con el programa more.  

'more' permite realizar una pausa en pantalla si el texto a mostrar no cabe en la
terminal. Pero además permite multiples cosas más como ejecutar comandos.  

Para solucionar este problema tengo que ajustar la terminal con un tamaño pequeño realizar la para conexión con ssh a ver que pasa.  

Una vez dentro de more presion la letra v para entrar en vim.  

En vin escribo los siguientes comando:  

```sh
:set shell=/bin/bash     
:shell    # ->> ejecuto la variable de entorno en VIM.
```

`bandit26@bandit:~$ cat /etc/bandit_pass/bandit26`

*Nota: como ya estas en bandit26 ejecuta el siguiente comando:

`./bandit27-do cat /etc/bandit_pass/bandit27`

### - Bandit Level 26 → Level 27   


LEVEL GOAL: Good job getting a shell! Now hurry and grab the password for bandit27!  

S :>>

Ir al Level 25 → Level 26   

### - Bandit Level 27 → Level 28   


LEVEL GOAL: There is a git repository at ssh://bandit27-git@localhost/home/bandit27-git/repo via the port 2220. The password for the user bandit27-git is the same as for the user bandit27.  

Clone the repository and find the password for the next level.  

S :>>
```sh
mktemp -d
cd /tmp/ID
git clone 
ssh://bandit27-git@localhost:2220/home/bandit27-git/repo
ls 
cd repo
cat README
```

### - Bandit Level 28 → Level 29   

LEVEL GOAL: There is a git repository at ssh://bandit28-git@localhost/home/bandit28-git/repo via the port 2220. The password for the user bandit28-git is the same as for the user bandit28.  

Clone the repository and find the password for the next level.  

S :>>
```sh
mktemp -d
cd /tmp/ID
git clone 
ssh://bandit27-git@localhost:2220/home/bandit27-git/repo
ls 
cd repo
cat README.txt
git log -p
```

### - Bandit Level 29 → Level 30   


LEVEL GOAL: There is a git repository at ssh://bandit29-git@localhost/home/bandit29-git/repo via the port 2220. The password for the user bandit29-git is the same as for the user bandit29.  

Clone the repository and find the password for the next level.  

S :>>

```sh
mktemp -d
cd /tmp/ID
git clone 
ssh://bandit29-git@localhost:2220/home/bandit29-git/repo
cd repo
cat README
git branch -a
git checkout LOG-ID 
# O
# git log -p
```  

### - Bandit Level 30 → Level 31   

LEVEL GOAL: There is a git repository at ssh://bandit30-git@localhost/home/bandit30-git/repo via the port 2220. The password for the user bandit30-git is the same as for the user bandit30.  

Clone the repository and find the password for the next level.  

Solución:    

```sh
mktemp -d
cd /tmp/ID
git clone 
ssh://bandit29-git@localhost:2220/home/bandit29-git/repo
cd repo
cat README.md
git tag
git show secret
```

### - Bandit Level 31 → Level 32   


LEVEL GOAL: There is a git repository at ssh://bandit31-git@localhost/home/bandit31-git/repo via the port 2220. The password for the user bandit31-git is the same as for the user bandit31.  

Clone the repository and find the password for the next level.  

S :>>  

```sh
mktemp -d
cd /tmp/ID
git clone ssh://bandit31-git@localhost:2220/home/bandit31-git/repo
cd repo
cat README.md
touch key.txt && echo "	 I come in?" > key.txt
nano .gitignore  ->> comentar archivos txt
git add key.txt .gitignore
git status -s
git commit -m "up key.txt"
git push
```

### - Bandit Level 32 → Level 33   

LEVEL GOAL: After all this git stuff, it’s time for another escape. Good luck!  

S :>>  

```sh
$0
cat /etc/bandit_pass/bandit33
```  

### - Bandit Level 33 → Level 34   


LEVEL GOAL:  NO EXISTE
S :>>
1.  

