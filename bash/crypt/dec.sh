#!/bin/bash

function listDirs {
	drtr=$(basename $1)
	newname=$(./crp-tools.sh decodeString $drtr)
	mv $drtr $newname
        find $newname -mindepth 1 -depth -exec ./crp-tools.sh decodeFilename {} \;
	find $newname -depth -type f -exec ./crp-tools.sh decodeFile {} {} \;
}

function mainDecodeFile() {
	ENCODED_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	echo decode $ENCODED_NAME
	DECODED_NAME=`./crp-tools.sh decodeString $ENCODED_NAME`
	./crp-tools.sh decodeFile $PATH_FILE/$ENCODED_NAME
	./crp-tools.sh decodeFilename $PATH_FILE/$ENCODED_NAME
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
