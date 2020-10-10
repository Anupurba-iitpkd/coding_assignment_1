#!/bin/bash

git add .
CUR_DATE=$(date)
echo $CUR_DATE
git commit -m "commit at : $CUR_DATE : $1"
git status 
git push --set-upstream origin master
