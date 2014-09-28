#!/bin/bash

#This script will copy the lib depencies of a binary to a target directory or to the current working directory.
# $1 binary to check
# $2 target - optional

if [ $# -gt 2 ] || [ $# -lt 1 ] ; then
    echo "Usage: $0 <binary to copy> <target, optional>"
    exit 1
fi

DEPS=`ldd $1 | sed -n 's/[^\/]*\(\/[^ ]*\).*/\1/p'`
DEPS="${DEPS} $1"

if [ -z $2 ] ; then
    TARGET=`pwd`
else
    TARGET=$2
fi

for i in ${DEPS}
do
    SUBDIR=`echo ${i} | sed -n 's/\(.*\)\/[^\/]*/\1/p'`
    echo "Copy ${i} to ${TARGET}/${SUBDIR}"
    mkdir -p ${TARGET}/${SUBDIR}
    cp -us ${i} ${TARGET}/${SUBDIR}
done
