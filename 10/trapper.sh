#!/bin/bash

# get pids of processes
PIDS=$(ps -ef | grep break | awk {'print$2'})

PARENT=$(echo $PIDS | cut -f1 -d" ")
CHILD=$(echo $PIDS | cut -f2 -d" ")
STEPCHILD=$(echo $PIDS | cut -f3 -d" ")



# SIGILL should load a string, fake or real, not sure. realistically, i think its just causing undefined behavior
#kill -SIGILL $PARENT

#SIGSEGV should load a string with PEEKDATA and POKEDATA
#kill -SIGSEGV $PARENT

# SIGTRAP is processed by parent handler to manipulate data
kill -SIGTRAP $PARENT

# SIGKILL kills
#kill -SIGKILL $PARENT


# PRINT STRINGS
# SIGTERM to parent will print phoenix string
#kill -SIGTERM $PARENT

# SIGQUIT to parent will print winners never quit string
#kill -SIGQUIT $PARENT

# SIGINT to parent prints the conch string.
#kill -SIGINT $PARENT

# SIGALRM to child should set some data in a flag
#kill -SIGALRM $CHILD
