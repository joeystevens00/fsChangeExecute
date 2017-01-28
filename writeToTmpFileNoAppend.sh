tmpFile="/tmp/.fsChangeExecute.tmp"


function writeToTmpFileNoAppend() {
	tmpdata="$1"
    if [ -n "$1" ]; then # If data passed as arg
    	tmpdata=$1
    else
    	while read pipe; do #  Otherwise Read pipe
    		tmpdata=$pipe
    	done
    fi
	echo "$tmpdata" > "$tmpFile"
}
