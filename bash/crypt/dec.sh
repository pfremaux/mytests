#!/bin/bash

function encodeFile() {
	openssl enc -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function decodeFile() {
	openssl enc -d -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function listDirs {
	drtr=$(basename $1)
#	for d in `find $drtr -maxdepth 1 -type d`
#	do
#		listFiles $d $2
#	done
#	find $drtr -depth -exec ./crp-tools.sh decodeFilename {} \; -type d
	newname=$(./crp-tools.sh decodeString $drtr)
	mv $drtr $newname
	echo decode les noms ...
        find $newname -mindepth 1 -depth -exec ./crp-tools.sh decodeFilename {} \;
	echo decode les contenus
	find $newname -depth -type f -exec ./crp-tools.sh decodeFile {} {} \;
}
function listFiles {
	declare -a listFile
        i=0
        for f in `find $1 -maxdepth 1 -type f`
        do
            listFile[$i]=$f
			i=$((i+1))
        done
        for i in ${listFile[*]}; do
            $2 $i
        done
}

function mainDecodeFile() {
	ENCODED_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	echo decode $ENCODED_NAME
	DECODED_NAME=`./crp-tools.sh decodeString $ENCODED_NAME`
	decodeFile $PATH_FILE/$ENCODED_NAME $PATH_FILE/$DECODED_NAME
	rm $PATH_FILE/$ENCODED_NAME
}

export KEY_CRP=$(readlink -f ./cle.bin)
EXIST=`test -e $1`
if [ $? -ne 0 ]
then
        echo inexistant
        exit 1
elif [ -d $1 ]
then
	listDirs `basename $1` 'mainDecodeFile'
else
	mainDecodeFile $1
fi
exit 0
