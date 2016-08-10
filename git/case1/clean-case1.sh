#!/bin/bash
git checkout branch-alice
git rm file*
git checkout branch-bob
git rm file*
git checkout branch-carol
git rm file*
git checkout master
git branch -D branch-alice
git branch -D branch-bob
git branch -D branch-carol

