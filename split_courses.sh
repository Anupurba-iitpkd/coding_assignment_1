#!/bin/bash



#function to split the master.csv file into branch wise files
function split_branches(){
	
	grep 'CS' master.csv > branch_CS.csv
	grep 'ME' master.csv > branch_ME.csv
	grep 'CE' master.csv > branch_CE.csv
	grep 'EE' master.csv > branch_EE.csv


}

split_branches

#function to prepare the unique courses list for each branch for further proceedngs:
function create_unique_course_list(){
	
	CE= cut -d, -f2 branch_CE.csv| sort -d | uniq  > branch_CE_Course_list
	ME= cut -d, -f2 branch_ME.csv | sort -d | uniq > branch_ME_Course_list
	CS= cut -d, -f2 branch_CS.csv | sort -d | uniq > branch_CS_Course_list
	EE= cut -d, -f2 branch_EE.csv | sort -d | uniq > branch_EE_Course_list
}

create_unique_course_list


# function to create all courses from each and every branch :
function create_all_courses(){
	
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

create_all_courses

option=''
source="/home/anupurba/prog_lab_week2/lab1"
dest='/temp'

while getopts :sg: option
do
	case $option in
	s)
		echo "received $option"
		echo "option argument is $OPTARG"
		make
		;;
	g)
		arr_args=($OPTARG)
		arr_args_count=${#arr_args[@]}
		echo $arr_args_count
		re='^[0-9]+$'
		echo "received $option"
		echo "option argument is ${arr_args[@]}"
		echo "number of arguments passed is : ${#arr_args[@]}"
		if [[ ${#arr_args[@]} > 3 ]]
		then 
			echo "too many arguments to option"
			exit 0
		else
			./generator ${arr[0]} > "${arr[1]}.csv"
		fi
	
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
		;;
	esac
done






