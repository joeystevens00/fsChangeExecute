# fsChangeExecute

Parses output from inotifywait and sets environment variables based on output allowing you to easily build logic to execute
different commands based on the events  

## Example usage
Using example/directoryWasCreated.sh

` bash fsChangeExecute.sh -d="test" -c="bash example/directoryWasCreated.sh" -e="create"`

![ss](http://i.imgur.com/6kaXFSc.png)

Using example/fileEventLogic.sh

` bash fsChangeExecute.sh --file='test/test.txt' --command='bash example/fileEventLogic.sh'`

![ss2](http://i.imgur.com/DVNBqtT.png)


## Flags
```
fsChangeExecute.sh --(file|directory)=[option] --command=[option] --events=[option]]
        -f |--file              the file to monitor
        -d |--directory the directory to monitor 
        -c | --command  the command to execute when events happen
        -i | --ignore-swapfiles 
                                        ignore events related to swap files (*.swp)
        -e | --events   the events to monitor
                                                defaults to all events
        -h | --help     displays this page
        -x | --exclude  ignore events that match REGEXP
        -v | --verbose  be verbose
```

## Environment variables
There are a few environment variables that you can access in your --command scripts

ENV_isDirectory - Contains "ISDIR" if the event happned to a directory (empty if not)  
ENV_eventFile - Contains the file or directory that the event happened to  
ENV_monitoredDirectory - Contains the directory that is being monitored  
ENV_eventDirectory - Contains the directory that the event happend in  
ENV_executedFromDirectory - Contains the directory that fsChangeExecute was executed from  
ENV_eventType - Contains the type of event (e.g. create, access, modified, etc)  
