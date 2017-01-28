#!/bin/bash
shopt -s nocasematch
eventType=$ENV_eventType
filepath="$ENV_executedFromDirectory/$ENV_eventFile"
if [[ "$eventType" == "access" ]];then
	echo "$filepath was accessed"
elif [[ "$eventType" == "move" ]]; then
	echo "$filepath was moved"
elif [[ "$eventType" == "delete" ]]; then
	echo "$filepath was deleted"
elif [[ "$eventType" == "open" ]]; then
	echo "$filepath was opened"
elif [[ "$eventType" == "close_write" ]]; then
	echo "$filepath was closed after being open in write mode"
elif [[ "$eventType" == "close_nowrite" ]];then
	echo "$filepath was closed after being open in read mode"
elif [[ "$eventType" == "modify" ]]; then
	echo "$filepath was modified"
fi