#!/bin/bash

function listDirs {
	drtr=$(basename $1)
	find $drtr -depth -type f -exec ./crp-tools.sh encodeFile {} {} \;
	find $drtr -depth -exec ./crp-tools.sh encodeFilename {} \;

}

function mainEncodeFile() {
	FILE_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	echo encode $FILE_NAME
	ENCODED_NAME=$(./crp-tools.sh encodeString $FILE_NAME)
	./crp-tools.sh encodeFile $PATH_FILE/$FILE_NAME
	./crp-tools.sh encodeFilename $PATH_FILE/$FILE_NAME
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

