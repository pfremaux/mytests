#!/bin/bash

function encodeFile() {
	openssl enc -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function decodeFile() {
	openssl enc -d -aes-256-cbc -salt -in $1 -out $2 -pass file:./cle.bin
}
function listDirs {
	drtr=$(basename $1)
	find $drtr -depth -type f -exec ./crp-tools.sh encodeFile {} {} \;
	find $drtr -depth -exec ./crp-tools.sh encodeFilename {} \;

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

function mainEncodeFile() {
	FILE_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	echo encode $FILE_NAME
	ENCODED_NAME=$(./crp-tools.sh encodeString $FILE_NAME)
	encodeFile $PATH_FILE/$FILE_NAME $PATH_FILE/$ENCODED_NAME
	rm $PATH_FILE/$FILE_NAME
}

export KEY_CRP=$(readlink -f ./cle.bin)
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

