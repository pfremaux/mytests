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
        echo traitement pour le repertoire `basename $d`
        listFiles $d $2
        done
}
function listFiles {
	declare -a listFile
        i=0
        for f in `find $1 -type f -maxdepth 1`
        do
                listFile[$i]=$f
		i=$((i+1))
                #$2 $f
        done
        for i in ${listFile[*]}; do
                $2 $i
        done

}

function mainDecodeFile() {
	ENCODED_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	DECODED_NAME=`./crp-tools.sh decodeString $ENCODED_NAME`
	decodeFile $PATH_FILE/$ENCODED_NAME $PATH_FILE/$DECODED_NAME
	rm $PATH_FILE/$ENCODED_NAME
}

EXIST=`test -e $1`
if [ $? -ne 0 ]
then
        echo inexistant
        exit 1
elif [ -d $1 ]
then
	listDirs $1 'mainDecodeFile'
else
	mainDecodeFile $1
fi
exit 0
