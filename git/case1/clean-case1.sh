#!/bin/bash
git checkout branch-alice
git rm file*
git checkout branch-bob
git rm file*
git checkout branch-carol
git rm file*
git checkout master
git branch -d branch-alice
git branch -d branch-bob
git branch -d branch-carol

