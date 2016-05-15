#!/bin/sh


die() { echo "$@" 1>&2 ; exit 1; }

NUM_CPU=$1
APP=$2
ARG_LEN=$#

if [ $# -ne 2 ]; then
    die "Usage: test.sh <num of processes> <app name>"    
fi;

START=$(date +"%s%N")

mpiexec -n $NUM_CPU $APP

END=$(date +"%s%N")

RES=$(echo "$END - $START" | bc)
echo "$RES ns"
