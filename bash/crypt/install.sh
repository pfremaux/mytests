#!/bin/bash
#openssl genrsa -out cles.pem 1024
openssl rand -base64 32 > cle.bin
