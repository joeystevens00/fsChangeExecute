# fsChangeExecute

Monitors files and/or directories and executes commands when specified events happen

## Example usage
Using directoryWasCreated.sh

` bash fsChangeExecute.sh -d="test" -c="bash example/directoryWasCreated.sh" -e="create"`

![ss](http://i.imgur.com/6kaXFSc.png)


## Flags
```
fsChangeExecute.sh --(file|directory)=[option] --command=[option] --events=[option]]
        -f |--file              the file to monitor
        -d |--directory the directory to monitor 
        -c | --command  the command to execute when events happen
        -e | --events   the events to monitor
                                                defaults to all events
        -h | --help     displays this page
```


