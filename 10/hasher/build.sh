#!/bin/bash

#gcc -no-pie -zexecstack sample.c -osample
gcc -m32 -no-pie -zexecstack hasher.c -ohasher -g
