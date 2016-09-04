#!/bin/bash

function encodeFile() {
	openssl enc -aes-256-cbc -salt -in $1 -out $2 -pass file:$KEY_CRP
}
function decodeFile() {
	openssl enc -d -aes-256-cbc -salt -in $1 -out $2 -pass file:$KEY_CRP
}
function encodeFilename() {
	filename=$(basename $1)
	dirname=$(dirname $1)
	#echo mv $dirname/$filename $dirname/$(encodeString $filename)
	mv $dirname/$filename $dirname/$(encodeString $filename)
}
function decodeFilename() {
	filename=$(basename $1)
	dirname=$(dirname $1)
	#echo mv $dirname/$filename $dirname/$(decodeString $filename)
	mv $dirname/$filename $dirname/$(decodeString $filename)
}
function encodeString() {
	VALEUR="$(echo $* | openssl enc -aes-256-cbc -salt -pass file:$KEY_CRP | base64)"
	echo ${VALEUR//\//-}
}
function decodeString() {
	VALEUR=${1//-/\/}
	echo $VALEUR | base64 --decode | openssl enc -d -aes-256-cbc -salt -pass file:$KEY_CRP
}
function listDirs {
        for d in `find $1 -type d`
        do
        	listFiles $d $2
        done
}
function listFiles {
        for f in `find $1 -type f`
        do
		$2 $f
        done
}

function mainEncodeFile() {
	FILE_NAME=`basename $1`
	PATH_FILE=`dirname $1`
	ENCODED_NAME=`encodeString $FILE_NAME`
	echo encode $PATH_FILE/$FILE_NAME vers $PATH_FILE/$ENCODED_NAME
	encodeFile $PATH_FILE/$FILE_NAME $PATH_FILE/$ENCODED_NAME
}

$*
