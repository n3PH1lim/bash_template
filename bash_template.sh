#!/bin/bash
#
#	Title:			bash_script_template.sh
#  Desc:		template for bash scripts
#  Author:		n3PH1lim
#  Git:			https://github.com/n3PH1lim
#  Creation:	20160213
#

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++ ENVIROMENT +++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

SCRIPT_TASK="Script Template"

# set strict mode
readonly STRICT=1

# set debug mode
readonly DEBUG=0

# set bash debug mode
readonly BASH_DEBUG=0

# set max working time of script in seconds
readonly MAX_WORKING_TIME=180

# stop on errors 
set -e 

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++ DECLARATIONS ++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# Set working directory use actual directory
readonly WORKDIR=$(pwd)

# get scriptname and remove dir part
readonly SCRIPTNAME_WITH_EXTENTION=${0##*/} 

# remove extension from scriptname
readonly SCRIPTNAME=${SCRIPTNAME_WITH_EXTENTION%.*} 

# set logfile name with monthly suffix  
readonly LOGFILE=${WORKDIR}/${SCRIPTNAME}$(date +'_%Y_%m_%d').log 

# set working file name for multiple run prevention
# use scriptname with _working suffix
readonly WORKING_FILE=${WORKDIR}/.${SCRIPTNAME}_working


# set color for nice cli 
readonly BOLD=$(tput bold)
readonly RESET=$(tput sgr0)
readonly UNDERLINE=$(tput sgr 0 1)
readonly PURPLE='\033[1;35m'
readonly RED='\033[1;31m'
readonly GREEN='\033[1;32m'
readonly TAN='\033[1;33m'
readonly BLUE='\033[1;34m'


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++ FUNCTIONS ++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# check_bash_debug
# Parameter:
# global parameter BASH_DEBUG
#
# Info:
# 1. if global BASH_DEBUG is 1 set bash debug mode
# 2. if global BASH_DEBUG is 0 do nothing
#
function check_bash_debug () {

if [ "${BASH_DEBUG}" == "1" ]
then :

	set -x

fi

}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# check_strict
# Parameter:
# global parameter STRICT
#
# Info:
# 1. if global STRICT is 1 set strict mode
# 2. if global STRICT is 0 do nothing
function check_strict () {

if [ "${STRICT}" == "1" ]
then :

	set -o nounset

fi

}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# debug printig
#
# Parameter:
# $1 string which is printed with timestamp in debug mode
#
# Info:
# 1. if global DEBUG is 1 print debug message
# 2. if global DEBUG is 0 do nothing
#
function decho(){

local STRING=$1

if [ $DEBUG -eq 1 ]
	then :
	echo -e "$(date '+%F %T'): ${STRING}"
	echo -e "$(date '+%F %T'): ${STRING}" >>${LOGFILE}
fi

unset STRING
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# timestamp printig
#
# Parameter:
# $1 string which is printed with timestamp
#
# Info:
# 1. print string with timestamp
#
function techo(){

local STRING=$1

echo -e "$(date '+%F %T'): ${STRING}"
echo -e "$(date '+%F %T'): ${STRING}" >>${LOGFILE}
	
unset STRING
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# print header
#
# Parameter:
# $1 string which is printed in header
#
# Info:
# 1. print header with string
#
function print_header() {

	local STRING=$1
	
	echo -e "$(date '+%F %T'):==========  ${STRING}  ==========" >>${LOGFILE}
	printf "\n${BOLD}${PURPLE}==========  %s  ==========${RESET}\n" "${STRING}"
	
	unset STRING
	
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# print_success
#
# Parameter:
# $1 string which is printed with success message
#
# Info:
# 1. print success with string
#
function print_success() { 

	local STRING=$1

	echo -e "$(date '+%F %T'): SUCESS: ${STRING}" >>${LOGFILE}
	printf "${GREEN}✔ %s${RESET}\n" "${STRING}" 
	
	unset STRING
		
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# print_error
#
# Parameter:
# $1 string which is printed with error message
#
# Info:
# 1. print error with string
#
function print_error() {

	local STRING=$1
		
	echo -e "$(date '+%F %T'): ERROR: ${STRING}" >>${LOGFILE}
	printf "${RED}✖ %s${RESET}\n" "${STRING}" 

	unset STRING
}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# print_warning
#
# Parameter:
# $1 string which is printed with warning message
#
# Info:
# 1. print warning with string
#
function print_warning() { 

	local STRING=$1

	echo -e "$(date '+%F %T'): WARNING: ${STRING}" >>${LOGFILE}
	printf "${TAN}★ %s${RESET}\n" "${STRING}"

	unset STRING
}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# print_note
#
# Parameter:
# $1 string which is printed with note message
#
# Info:
# 1. print note with string
#
function print_note() {

	local STRING=$1
	
	echo -e "$(date '+%F %T'): NOTE: ${STRING}" >>${LOGFILE}
	printf "${UNDERLINE}${BOLD}${BLUE}Note:${RESET}  ${BLUE}%s${RESET}\n" "${STRING}"

	unset STRING

}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# remove_file
#
# Parameter:
# $1 full filepath
#
# Info:
# 1. remove file $1
#
function remove_file(){

local FUNCTION_TEMP_FILE=${1}

if [ -f ${FUNCTION_TEMP_FILE} ]
then :
	decho "DEBUG: file ${FUNCTION_TEMP_FILE} exists"
	decho "DEBUG: removing file ${FUNCTION_TEMP_FILE}"
	rm ${FUNCTION_TEMP_FILE}
else :
	techo "ERROR: $(date '+%F %T'): ERROR: file ${FUNCTION_TEMP_FILE} not exists"
fi

unset FUNCTION_TEMP_FILE

}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# check_working
#
# Parameter:
# $1 Name of working file 
# $2 max age of working file in seconds
#
# Info:
# 1. check if script already working 
# 2. write working file with exclusive filehandle
# 3. if working file is older than n seconds delete working file
# 4. if filehandle can not taken exit
#
function check_working(){

# save paramter temporary
FUNCTION_WORKING_FILE=${1}
TEMP_MAX_AGE=${2}

# check if working file already exists
if [ -f ${FUNCTION_WORKING_FILE} ]
then :
	# get age of working file in seconds
	WORKING_FILE_AGE=$(expr $(date +%s) - $(date +%s -r ${FUNCTION_WORKING_FILE}))

	# check if working file older then TEMP_MAX_AGE
	if [ ${WORKING_FILE_AGE} -gt ${TEMP_MAX_AGE} ] # this nooooot working
	then :
		techo "WARN: working file ${FUNCTION_WORKING_FILE} is older than ${TEMP_MAX_AGE}"
		techo "WARN: deleting old working file ${FUNCTION_WORKING_FILE}"
		rm ${FUNCTION_WORKING_FILE}
	else
		decho "DEBUG: working file ${FUNCTION_WORKING_FILE} found"
		techo "WARN: script is already working"
		decho "WARN: exit script"
		exit 1
	fi
else :
	decho "DEBUG: working file ${FUNCTION_WORKING_FILE} not found all ok"
fi


# open file descriptor
exec 200>$FUNCTION_WORKING_FILE

# get exclusiv file lock or exit
flock -n 200 || (techo "FATAL: filehandle on working file can not be opend" && exit 1)

# cleanup wokring file when script is exiting
trap 'remove_file ${FUNCTION_WORKING_FILE}' EXIT 0

# get script pid
local PID=$$

# print pid in working file
echo $PID 1>&200

}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# start_processing
#
# Parameter:
# global variable SCRIPT_TASK using for
# description what script is doing
#
# Info:
# print header at start of script
# and run some cheks
#
function start_processing(){

# clear screen
clear

# set some space
echo -e  "\n\n"
echo -e  "\n\n" >>${LOGFILE}

# check if bash debug is set
check_bash_debug

# check if script run in strict mode
check_strict

# multiple run prevention
check_working ${WORKING_FILE} ${MAX_WORKING_TIME}

# print header
print_header "START ${SCRIPT_TASK}"

}


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# end_processing
#
# Parameter:
# Parameter:
# global variable SCRIPT_TASK using for
# description what script is doing
#
#
# Info:
# print header at end of script
#
function end_processing(){

# print header
print_header "FINISHED ${SCRIPT_TASK}"

}

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++ MAIN +++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

start_processing

techo "Start processing backup." 


print_error "TEXT"
print_note "TEXT"
print_success "TEXT"
print_warning "TEXT"

end_processing

exit 0

