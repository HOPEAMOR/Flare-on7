#!/bin/bash

# build binaries
./build.sh

#run test
export LD_PRELOAD=../preload.so
./test

