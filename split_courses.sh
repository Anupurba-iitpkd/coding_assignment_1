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

function remove_duplicates(){


	$COURSE_FILE="$1"
	echo "${COURSE_FILE}"
	sort -t"," -k 1,1 -k 3,3 -n -r "${COURSE_FILE}" -o "${COURSE_FILE}"
	awk -F"," '!seen[$1]++' "${COURSE_FILE}" > "${COURSE_FILE}_dr"
	cat "${COURSE_FILE}_dr" > "${COURSE_FILE}"
	rm "${COURSE_FILE}_dr"

}

# function to create all courses from each and every branch :
function create_all_courses(){
	

split_branches

create_unique_course_list

#creating the unique course files for CE branch
while read -r LINE
do
	grep "$LINE"  branch_CE.csv > "courses/CE/${LINE}.csv"
	CE_FILE_NAME="courses/CE/${LINE}.csv"
	sort -t"," -k 1,1 -k 3,3 -n -r ${CE_FILE_NAME} -o ${CE_FILE_NAME}
	awk -F"," '!seen[$1]++' ${CE_FILE_NAME} > "${CE_FILE_NAME}_dr"
	cat "${CE_FILE_NAME}_dr" > ${CE_FILE_NAME}
	rm "${CE_FILE_NAME}_dr"
#	remove_duplicates $CE_FILE_NAME
done < branch_CE_Course_list


#creating the unique course files for ME branch
while read -r LINE
do
	grep "$LINE"  branch_ME.csv > "courses/ME/${LINE}.csv"

	ME_FILE_NAME="courses/ME/${LINE}.csv"
	sort -t"," -k 1,1 -k 3,3 -n -r $ME_FILE_NAME -o $ME_FILE_NAME
	awk -F"," '!seen[$1]++' $ME_FILE_NAME > "${ME_FILE_NAME}_dr"
	cat ${ME_FILE_NAME}_dr > $ME_FILE_NAME
	rm ${ME_FILE_NAME}_dr
done < branch_ME_Course_list


#creating the unique course files for CS branch
while read -r LINE
do
	grep "$LINE"  branch_CS.csv > "courses/CS/${LINE}.csv"

	CS_FILE_NAME="courses/CS/${LINE}.csv"
	sort -t"," -k 1,1 -k 3,3 -n -r $CS_FILE_NAME -o $CS_FILE_NAME
	awk -F"," '!seen[$1]++' $CS_FILE_NAME > "${CS_FILE_NAME}_dr"
	cat ${CS_FILE_NAME}_dr > $CS_FILE_NAME
	rm ${CS_FILE_NAME}_dr
done < branch_CS_Course_list

#creating the unique course files for EE branch
while read -r LINE
do
	grep "$LINE"  branch_EE.csv > "courses/EE/${LINE}.csv"

	EE_FILE_NAME="courses/EE/${LINE}.csv"
	sort -t"," -k 1,1 -k 3,3 -n -r $EE_FILE_NAME -o $EE_FILE_NAME
	awk -F"," '!seen[$1]++' $EE_FILE_NAME > "${EE_FILE_NAME}_dr"
	cat ${EE_FILE_NAME}_dr > $EE_FILE_NAME
	rm ${EE_FILE_NAME}_dr

done < branch_EE_Course_list
}

#function to create specific courses when -c is pressed
function create_specific_course(){

	split_branches
	create_unique_course_list
	COURSE_NAME=$1
	BRANCH_NAME=${COURSE_NAME:0:2}
	grep "$COURSE_NAME" "branch_${BRANCH_NAME}.csv" > "/home/anupurba/prog_lab_week2/lab1/courses/${BRANCH_NAME}/${COURSE_NAME}.csv"

	COURSE_PATH="/home/anupurba/prog_lab_week2/lab1/courses/${BRANCH_NAME}/${COURSE_NAME}.csv"
	
	#code to sort the file
	sort -t"," -k 1,1 -k 3,3 -n -r "${COURSE_PATH}" -o "${COURSE_PATH}"
	awk -F"," '!seen[$1]++' "${COURSE_PATH}" > "${COURSE_PATH}_dr"
	cat  "${COURSE_PATH}_dr" > "${COURSE_PATH}"
	rm "${COURSE_PATH}_dr"

}

#function to create specific branches when -b is pressed
function create_specific_branches(){
	
	BRANCH_NAME=$1
	grep "$BRANCH_NAME" ${FILE_NAME} > "branch_${BRANCH_NAME}.csv"



}
# code to take arguments and evaluate options : 
	
	if [ "$#" = 0 ]
	then
		echo "expected options. -h for help"
		exit 101
	else
	
		while getopts :sg:c:ab: option
		do
		case $option in
		s|--setup)
			mkdir courses
			mkdir courses/CE
			mkdir courses/CS
			mkdir courses/EE
			mkdir courses/ME
			make
			;;
		g|--generate)
			generate_master
			;;
		c|--course)
			arr_c_args=($OPTARG)
			for i in ${arr_c_args[@]}
			do
				create_specific_course $i
			done
			;;
		b)
			arr_b_args=($OPTARG)
			for i in ${arr_b_args[@]}
			do
				create_specific_branches $i
			done
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
	fi
	













