#!/bin/bash

#this file will be tested

function print_out()
{
    echo "test this function"
    APPLE=123
    return $1
}

function main()
{
    print_out 10
}

if [ -z $UNIT_TEST ] ; then
    main
fi
