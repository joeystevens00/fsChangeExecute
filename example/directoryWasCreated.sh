#!/bin/bash
# AUTHOR:  Joey Stevens
# Description: This file shows how to detect when a directory was created using the
# fsChangeExecute environment variables
if [ $ENV_isDirectory ]; then
	newDirName=$ENV_eventFile
	path="$ENV_executedFromDirectory/$ENV_eventDirectory/$newDirName"
	echo "A new directory named $ENV_eventFile was created at $path"
fi
