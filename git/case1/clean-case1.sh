#!/bin/bash
git checkout branch1-alice
git rm file*
git checkout branch1-bob
git rm file*
git checkout branch1-carol
git rm file*
git checkout master
git branch -d branch1-alice
git branch -d branch1-bob
git branch -d branch1-carol

