#!/bin/bash

function encodeFile() {
	openssl enc -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function decodeFile() {
	openssl enc -d -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function listDirs {
        for d in `find $1 -type d -maxdepth 1`
        do
    	   	echo traitement pour le repertoire $d
      	 	listFiles $d $2
		#listDirs $d $2
        done
	#listFiles $1 $2
}
function listFiles {
	declare -a listFile
	i=0
	echo recherche de fichier dans $1 et executera la commande $2
        for f in `find $1 -type f -maxdepth 1`
        do
                echo note le fichier $f = `basename $f`
		listFile[$i]=$f
		i=$((i+1))
		#$2 $f
        done
	echo fichiers a encoder ${listFile[*]}:
	for i in ${listFile[*]}; do
        	echo $i
		$2 $i
	done
}

function mainEncodeFile() {
	FILE_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	ENCODED_NAME=$(./crp-tools.sh encodeString $FILE_NAME)
	echo encode $PATH_FILE/$FILE_NAME vers $PATH_FILE/$ENCODED_NAME
	#DECODED_NAME=`decodeString $ENCODED_NAME`
	#echo decode $ENCODED_NAME vers $DECODED_NAME
	encodeFile $PATH_FILE/$FILE_NAME $PATH_FILE/$ENCODED_NAME
	rm $PATH_FILE/$FILE_NAME
}

EXIST=`test -e $1`
if [ $? -ne 0 ]
then
        echo inexistant
        exit 1
elif [ -d $1 ]
then
        #echo repertoire
        listDirs `basename $1` 'mainEncodeFile'
else
	mainEncodeFile $1
        #listFiles $1
fi
exit 0

#decodeString `encodeString 'toto pierre'`
#openssl enc -aes-256-cbc -salt -in $1 -out $1.enc -pass file:./cle.bin
