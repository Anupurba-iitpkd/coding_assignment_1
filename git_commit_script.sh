#!/bin/bash

git add .
CUR_DATE=$(date)
echo $CUR_DATE
git commit -m "commit at : $CUR_DATE"
