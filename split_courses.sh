#!/bin/bash

grep 'CS' master1.csv > branch_CS.csv
grep 'ME' master1.csv > branch_ME.csv
grep 'CE' master1.csv > branch_CE.csv
grep 'EE' master1.csv > branch_EE.csv

#mkdir courses/CE

CE= cut -d, -f2 branch_CE.csv| sort -d | uniq  > branch_CE_Course_list
echo "$CE"

while read -r LINE
do
	echo $LINE > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv" 

done < branch_CE_Course_list
