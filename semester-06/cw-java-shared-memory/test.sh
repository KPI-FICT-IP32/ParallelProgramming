#!/bin/sh


die() { echo "$@" 1>&2 ; exit 1; }

NUM_CPU=$1
SIZE=$2
APP=$3

if [ $# -ne 3 ]; then
    die "Usage: test.sh <num of processes> <size> <app name>"    
fi;

START=$(date +"%s%N")

java -Dpp.size=$SIZE -Dpp.processes=$NUM_CPU -jar $APP

END=$(date +"%s%N")

RES=$(echo "$END - $START" | bc)
echo "$RES ns"
