#!/bin/bash

source /shu_inc/globals.sh

TEST_PID=0

function assert_res_ok()
{
    echo -n "."
}

function shu_error()
{
    echo "$1" >> ${TESTSET_TEMP_FILE}
}
function assert_res_fail()
#$1 - assert name
{
    echo -n "X"
    shu_error
    shu_error
    echo `cat ${LAST_TEST_TEMP_FILE}` "[ $1 ]" >> ${TESTSET_TEMP_FILE}
    shu_error
}
function ASSERT_FILE()
#$1 - expected output
#$2 - filename
{
    grep -q "$1" "$2" 
    if [ $? == 0 ] ; then
        assert_res_ok
        return 0
    else
        assert_res_fail "ASSERT_[OUTPUT|ERROR|SYSLOG] ($2)"
        shu_error "     not equal to excepted"
        shu_error
        shu_error "excepted:"
        shu_error "     |$1|"
        shu_error "got:"
        shu_error "     |`cat $2`|" >> ${TESTSET_TEMP_FILE}
        return 1
    fi
}

function ASSERT_ERROR()
# $1 - excepted error printout
{
    ASSERT_FILE "$1" ${STDERR_TEMP_FILE}
}

function ASSERT_OUTPUT()
# $1 - excepted output (stdout)
{
    ASSERT_FILE "$1" ${STDOUT_TEMP_FILE}
}

function ASSERT_SYSLOG()
# $1 - excepted log in syslog
{
    ASSERT_FILE "$1" /var/log/syslog
}

function ASSERT_EQ()
{
    if [ "$1" == "$2" ] ; then
        assert_res_ok
        return 0
    else
        assert_res_fail "ASSERT_EQ"
        shu_error "excepted: $1, got: $2"
        return 1
    fi
}

function ASSERT_NO_ERROR()
{
    if [ -s ${STDERR_TEMP_FILE} ] ; then
        assert_res_fail "ASSERT_NO_ERROR"
        shu_error "STDERR was not clear"
        shu_error "STDERR after function call:"
        cat ${STDERR_TEMP_FILE} >> ${TESTSET_TEMP_FILE}
        return 1
    else
        assert_res_ok
        return 0
    fi
}

function ASSERT_NO_OUTPUT()
{
    if [ -s ${STDOUT_TEMP_FILE} ] ; then
        assert_res_fail "ASSERT_NO_OUTPUT"
        shu_error "STDOUT was not clear"
        shu_error "STDOUT after function call:"
        cat ${STDOUT_TEMP_FILE} >> ${TESTSET_TEMP_FILE}
        return 1
    else
        assert_res_ok
        return 0
    fi
}

function ASSERT_NO_SYSLOG()
{
    if [ -s /var/log/syslog ] ; then
        assert_res_fail "ASSERT_NO_SYSLOG"
        shu_error "SYSLOG was not clear"
        shu_error "SYSLOG after function call:"
        cat /var/log/syslog >> ${TESTSET_TEMP_FILE}
        return 1
    else
        assert_res_ok
        return 0
    fi
}

function ASSERT_RETURN
#$1 - expected return value
{
    return_value=`cat ${RESULT_TEMP_FILE}`
    if [ $1 -eq ${return_value} ] ; then
        assert_res_ok
        return 1
    else
        assert_res_fail "ASSERT_RETURN"
        shu_error "Return value: ${return_value} excepted: $1"
        return 0
    fi
}

function TESTSET()
#$1 - name of the SET
{
    
    echo ; echo
    echo "=========================================================="
    echo " SET: $1"
    echo "=========================================================="
    echo -n "" > ${TESTSET_TEMP_FILE}
#    echo $$
    return
}

function TESTSET_END()
{
    echo ; echo
    echo "__________________________________________________________"
    if [ -s ${TESTSET_TEMP_FILE} ] ; then
        echo " Test set done."
        echo " Failed tests:" 
        cat ${TESTSET_TEMP_FILE}
        exit 1
    else
        echo " Every test passed."
        exit 0
    fi
    echo "=========================================================="
}

function TEST()
# $1 - test name
# $2 - function to test
# $3 - [FORK|NO_FORK]
# $4 - parameters for it
#
#example: TEST '001' 'echo' '"Cool" "really"'
{
    #echo ; echo
    echo -n "|"
    echo "$1" > ${LAST_TEST_TEMP_FILE}
    exec 6>&1 #Save STDOUT
    exec 1>${STDOUT_TEMP_FILE}
    exec 7>&2 #Save STDERR
    exec 2>${STDERR_TEMP_FILE}
 #   exec 8<&0 #Save STDIN
 #   exec 0<&- #Tilt STDIN

    #Remove any syslog
    rm -f /var/log/syslog

    if [ $3 == "FORK" ] ; then
        eval "$2 $4 &"
        LAST_PID=$!
        wait ${LAST_PID}
    else
        eval "$2 $4"
    fi
    ret=$?

    echo $ret>${RESULT_TEMP_FILE}

    exec 1>&6
    exec 6>&-
    exec 2>&7
    exec 7>&-
#    exec 0<&8
#    exec 8<&
#    echo "RETURN: $ret"    
#    echo "LAST: ${LAST_PID}"
}

