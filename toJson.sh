# AUTHOR: Joey Stevens
# Description: Takes input and converts to json
#		Expects data in the form of:
#			key=value key2=value2 key3=value3
# Limitations: Currently doesn't support multiwords keys/values

function toJson() {
		unset pipe
        unset out
        if [ -n "$1" ]; then 
                data=$1
        else 
                while read pipe; do 
                        data=$pipe
                done
        fi
        for i in $(echo $data); do 
                key=$(echo $i | cut -d"=" -f1)
                value=$(echo $i | cut -d"=" -f2)
                out+="\"$key\": \"$value\","
        done
        out=$(echo $out | sed 's/,$//')
        out=$(echo "{ $out }")
        echo "$out"
}
