#!/bin/bash 


i=1
for file in courses/CE/*
do 
	if [ -f $file  ]
	then

		FILE_NAME=${file:11}
		echo "roll-number,$FILE_NAME" > "${file}_CE.csv"
		cut -d, -f 1,3 $file >> "${file}_CE.csv"
		
	fi
done

echo "$file"
join -a 2 --nocheck-order courses/CE/CE2010.csv_CE.csv courses/CE/CE2030.csv_CE.csv
