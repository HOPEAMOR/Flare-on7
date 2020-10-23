#!/bin/bash

# build preload
gcc -m32 -Wall -fPIC -shared -o ../preload.so preload.c

# build test
gcc -m32 test.c -otest
