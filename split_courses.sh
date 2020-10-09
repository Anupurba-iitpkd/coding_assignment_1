#!/bin/bash


#function to generate the master.csv file, i.e. the main content file. with or without passed file name (default file name : master.csv)
function generate_master(){

		arr_args=($OPTARG)
		arr_args_count=${#arr_args[@]}
		if [[ ${#arr_args[@]} > 2 ]]
		then 
			echo "too many arguments to option"
			exit 0
		else
			if echo ${arr_args[0]} | egrep -q '^[0-9]+$'
			then 
			     ./generator ${arr_args[0]} > "${arr_args[1]}.csv"
			     FILE_NAME="${arr_args[1]}.csv"
			else
			     echo "this argument should be numeric type"
			fi
		fi
		if [[ ${#arr_args[@]} = 1  ]]
		then
			 ./generator ${arr_args[0]} > master.csv
			 FILE_NAME=master.csv
		fi
}

#function to split the master.csv file into branch wise files
function split_branches(){
	
	grep 'CS' ${FILE_NAME} > branch_CS.csv
	grep 'ME' ${FILE_NAME} > branch_ME.csv
	grep 'CE' ${FILE_NAME} > branch_CE.csv
	grep 'EE' ${FILE_NAME} > branch_EE.csv


}


#function to prepare the unique courses list for each branch for further proceedngs:
function create_unique_course_list(){
	
	CE= cut -d, -f2 branch_CE.csv| sort -d | uniq  > branch_CE_Course_list
	ME= cut -d, -f2 branch_ME.csv | sort -d | uniq > branch_ME_Course_list
	CS= cut -d, -f2 branch_CS.csv | sort -d | uniq > branch_CS_Course_list
	EE= cut -d, -f2 branch_EE.csv | sort -d | uniq > branch_EE_Course_list
}


# function to create all courses from each and every branch :
function create_all_courses(){
	

split_branches

create_unique_course_list

#creating the unique course files for CE branch
while read -r LINE
do
	#	echo $LINE > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv" 
	grep "$LINE"  branch_CE.csv > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv"
done < branch_CE_Course_list


#creating the unique course files for ME branch
while read -r LINE
do
	#	echo $LINE > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv" 
	grep "$LINE"  branch_ME.csv > "/home/anupurba/prog_lab_week2/lab1/courses/ME/${LINE}.csv"
done < branch_ME_Course_list


#creating the unique course files for CS branch
while read -r LINE
do
	#	echo $LINE > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv" 
	grep "$LINE"  branch_CS.csv > "/home/anupurba/prog_lab_week2/lab1/courses/CS/${LINE}.csv"
done < branch_CS_Course_list

#creating the unique course files for EE branch
while read -r LINE
do
	#	echo $LINE > "/home/anupurba/prog_lab_week2/lab1/courses/CE/${LINE}.csv" 
	grep "$LINE"  branch_EE.csv > "/home/anupurba/prog_lab_week2/lab1/courses/EE/${LINE}.csv"

done < branch_EE_Course_list
}

# code to take arguments and evaluate options : 
while getopts :sg:c:a option
do
	case $option in
	s)
		echo "received $option"
		echo "option argument is $OPTARG"
		make
		;;
	g)
		generate_master
		;;
	c)
		arr_c_args=($OPTARG)
		arr_c_arg_count=${#arr_c_args[@]}
		create_all_courses
		;;
	a)
		echo "option generated : $option"
		create_all_courses
		;;
	:)
		echo "$OPTARG requires an argument"
		exit 101
		;;
	h)
		echo "help option"
		exit 0
		;;
	*)
		echo "invalid option, goto -h for help"
		exit 0
		;;
	esac
done













