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
      	 	listFiles $d $2
        done
}
function listFiles {
	declare -a listFile
	i=0
        for f in `find $1 -type f -maxdepth 1`
        do
                echo note le fichier $f = `basename $f`
		listFile[$i]=$f
		i=$((i+1))
        done
	for i in ${listFile[*]}; do
        	echo $i
		$2 $i
	done
}

function mainEncodeFile() {
	FILE_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	ENCODED_NAME=$(./crp-tools.sh encodeString $FILE_NAME)
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
        listDirs `basename $1` 'mainEncodeFile'
else
	mainEncodeFile $1
fi
exit 0

