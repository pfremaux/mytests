#!/bin/bash

git checkout -b branch-alice
echo alice message 1 > file-alice.txt
git add file*
git commit -m "alice : init my branch"
git checkout -b branch-bob
echo bob message 1 > file-bob.txt
git add file*
git commit -m "bob : init my branch"
git checkout -b branch-carol
echo carol message 1 > file-carol.txt
git add file*
git commit -m "carol : init my branch"
