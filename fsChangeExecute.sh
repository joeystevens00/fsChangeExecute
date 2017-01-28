#!/bin/bash
# AUTHOR: Joey Stevens
# Description: This script monitors a directory, 
# captures filesystem events and does stuff with those events
function eventTest() {
	shopt -s nocasematch
	event="$1"
	eventNotification="$2"
	isThisASwapFile=$(echo -e "$eventNotification" | grep -ioP "\..*\.swp")
	if [[ "$eventNotification" == *"$event"* ]] && [ -z "$isThisASwapFile" ]; then
		echo true;
	fi
}

function monitor() {
	inotifywait -m "$useDirectory" -e "modify" -e "create"  \
	 	-e "delete" -e "delete_self" -e "unmount" \
	 	-e "access" -e "attrib" -e "close_write" \
	 	-e "close_nowrite" -e "close" -e "open" \
		"$directory" "$file" | while read event; do 

		for eventToMonitor in $(echo $eventsToMonitor | tr ',' '\n'); do
			if [ $(eventTest "$eventToMonitor" "$event") ]; then 
			echo $event
			#echo `$command`
			fi 
		done
	done
}

displayHelp() {
	echo "Placeholder help content"
	sleep 1;
	less $0
	exit
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
        -h|--help=*)
    		help=true
            shift # past argument=value
        	;;
    	*)
	       	help=true # unknown option
    		;;
	esac
	done

	if [ "$help" == true ]; then displayHelp; fi
	if [ -n "$directory" ]; then useDirectory="-r"; fi
	if [ "$directory" ] && [ "$file" ]; then displayHelp; fi
	monitor
}
argParse "$@"
