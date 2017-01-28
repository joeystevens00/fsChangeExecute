#!/bin/bash
# AUTHOR: Joey Stevens
# Description: This script monitors a directory, 
# captures filesystem events and does stuff with those events

source toJson.sh
source writeToTmpFileNoAppend.sh

function eventTest() {
	shopt -s nocasematch
	event="$1"
	eventNotification="$2"
	
	if [ "$ignoreSwapFiles" ]; then 
		isThisASwapFile=$(echo "$eventNotification" | grep -ioP "\..*\.swp")
	else isThisASwapFile=""
	fi

	if [ "$excludeRegexp" ]; then
		doesTheExclusionMatch=$(echo "$eventNotification" | grep -ioP "$excludeRegexp")
	fi

	if [[ "$eventNotification" == *"$event"* ]] && [ -z "$isThisASwapFile" ] && [ -z "$doesTheExclusionMatch" ]; then
		echo true;
	fi
}

function getDirectoryFullPath() {
	if [ -z "$directory" ]; then 
		echo -n ""
	else
		currentPath=$PWD
		cd $directory
		directoryFullPath=$PWD
		cd $currentPath
		echo "$directoryFullPath"
	fi
}

function setEnvVariables() {
	tmpFileCurrent=$(cat $tmpFile)
	export ENV_isDirectory=$(echo -e "$tmpFileCurrent" | jq -r .isDirectory)
	export ENV_eventFile=$(echo -e "$tmpFileCurrent" | jq -r .eventFile)
	export ENV_monitoredDirectory=$(echo -e "$tmpFileCurrent" | jq -r .monitoredDirectory)
	export ENV_eventDirectory=$(echo -e "$tmpFileCurrent" | jq -r .eventDirectory)
	export ENV_executedFromDirectory=$(echo -e "$tmpFileCurrent" | jq -r .executedFromDirectory)
	export ENV_eventType=$(echo -e "$tmpFileCurrent" | jq -r .eventType)
}


function monitor() {
	eventsToMonitorCommandBuild=$(echo $eventsToMonitor | sed 's/^/-e /' | sed 's/,/ -e/g')
	inotifywaitCommand="inotifywait -m $useDirectory $eventsToMonitorCommandBuild $directory $file"
	`echo $inotifywaitCommand` | while read event; do 

		for eventToMonitor in $(echo $eventsToMonitor | tr ',' '\n'); do
			if [ $(eventTest "$eventToMonitor" "$event") ]; then 
				if [ "$beVerbose" ]; then echo $event; fi
				isDirectory=$(echo $event | grep -ioP "isdir") # Contains isdir
				eventFile=$(echo $event | grep -oP " ([[:alnum:]]|/|\.)+$") #Get the last word 
				eventFile=$(echo $eventFile | tr -d " ") # Remove whitespace
				eventDirectory=$(echo $event | grep -ioP "^.*? ") # The directory that the event happend in
				eventDirectory=$(echo $eventDirectory | sed 's/\/$//') # Remove the trailing /
				directoryFullPath=$(getDirectoryFullPath)
				# inotifywait doesn't output the event filename as the last word in single file mode
				if [ -z "$directory" ]; then eventFile=$eventDirectory; fi 
				# Using a string because passing arrays to functions sucks in bash
				keydata="isDirectory=$isDirectory eventFile=$eventFile \
				 		monitoredDirectory=$directoryFullPath eventDirectory=$eventDirectory \
				  		executedFromDirectory=$executedFromDirectory eventType=$eventToMonitor"
				#echo "$keydata"
				toJson "$keydata" | writeToTmpFileNoAppend
				setEnvVariables
				echo `$command`
			fi 
		done
	done
}

displayHelp() { 
cat << helpcontent
$0 --(file|directory)=[option] --command=[option] --events=[option]]
	-f |--file		the file to monitor
	-d |--directory	the directory to monitor 
	-c | --command	the command to execute when events happen
	-i | --ignore-swapfiles 
					ignore events related to swap files (*.swp)
	-e | --events   the events to monitor
						defaults to all events
	-h | --help     displays this page
	-x | --exclude  ignore events that match REGEXP
	-v | --verbose	be verbose
helpcontent
exit 1
}

argParse() {
	for i in "$@"; do
	case $i in
		-f=*|--file=*)
			file="${i#*=}"
			shift # past argument=value
            ;;
		-d=*|--directory=*)
    		directory="${i#*=}"
    		shift # past argument=value
    		;;
    	-c=*|--command=*)
    		command="${i#*=}"
    		shift # past argument=value
    		;;
    	-e=*|--events=*)
    		eventsToMonitor="${i#*=}"
    		shift # past argument=value
    		;;
    	-x=*|--exclude=*)
    		excludeRegexp="${i#*=}"
    		shift # past argument=value
    		;;
    	-i|--ignore-swapfiles)
    		ignoreSwapFiles=true
    		shift # past argument=value
    		;;
    	-v|--verbose)
    		beVerbose=true
    		shift # past argument=value
    		;;
        -h|--help=*)
    		help=true
            shift # past argument=value
        	;;
    	*)
	       	help=true # unknown option
    		;;
	esac
	done
	executedFromDirectory=$PWD
	if [ "$help" == true ]; then displayHelp; fi
	if [ -n "$directory" ]; then useDirectory="-r"; fi
	if [ "$directory" ] && [ "$file" ]; then displayHelp; fi
	if [ -z "$eventsToMonitor" ]; then 
		eventsToMonitor="access, modify, attrib, close_write, close_nowrite, close, open, moved_to, moved_from, move, move_self, create, delete, delete_self, unmount"
	fi	
	monitor
}
argParse "$@"