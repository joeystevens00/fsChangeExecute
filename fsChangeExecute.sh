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
		$directory | while read event; do 
		if [ $(eventTest "CREATE" "$event") ]; then 
			# Do something with "CREATE"
			#echo $event
			echo `$command`
		elif [ $(eventTest "MODIFY" "$event") ]; then
			echo $event
		elif [ $(eventTest "DELETE" "$event") ]; then
			# Used with the deletion of files and directories
			# rm -r test/ would trigger
			# DELETE, ISDIR test
			# rm test would trigger
			# DELETE test
			echo $event
		elif [ $(eventTest "DELETE_SELF" "$event") ]; then
			# Used with the deletion of directories. 
			# rm -r test/ would trigger
			# test/ DELETE_SELF
			echo $event
		elif [ $(eventTest "UNMOUNT" "$event") ]; then
			echo $event
		elif [ $(eventTest "ACCESS" "$event") ]; then
			echo $event
		elif [ $(eventTest "ATTRIB" "$event") ]; then
			echo $event
		elif [ $(eventTest "CLOSE_WRITE" "$event") ]; then
			echo $event
		elif [ $(eventTest "CLOSE_NOWRITE" "$event") ]; then
			echo $event
		elif [ $(eventTest "CLOSE" "$event") ]; then
			echo $event
		elif [ $(eventTest "OPEN" "$event") ]; then
			echo $event
		fi 
	done
}

displayHelp() {
	echo "Placeholder help content"
	sleep 1;
	less $0
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
	monitor
}
argParse "$@"
