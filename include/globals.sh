#!/bin/bash
#Test running related variables

DIR_SHU_TEST_ROOT='${HOME}/pro/shu'

DIR_TEST_ENV_TMP='/tmp/shu_test'
DIR_COMMON_ENV="${DIR_SHU_TEST_ROOT}/test_env_common"
#Relative ! Will be /${DIR_TC} on test env.
DIR_TC='utest'

NAME_PRE_SCRIPT='pre.sh'
NAME_POST_SCRIPT='post.sh'
NAME_START_TEST_SCRIPT='start.sh'
DIR_COMMON_SCRIPTS='common'
DIR_TS_ENV='test_env'
DIR_TC_ENV='test_env'
TEST_EXTENSIONS='.sh'

#Stuff below used by unit_test.sh

STDOUT_TEMP_FILE='/tmp/unittest_stdout'
STDERR_TEMP_FILE='/tmp/unittest_stderr'
RESULT_TEMP_FILE='/tmp/unittest_result'
TESTSET_TEMP_FILE='/tmp/unittest_testset'
LAST_TEST_TEMP_FILE='/tmp/unittest_lasttest'
UNIT_TEST=1

#Commonly used functions

function pERROR ()
{
    echo "[ ERROR ] $1"
}

function CHK_RES ()
{
    if [ $? != 0 ] ; then
        pERROR "$1"
        exit $2
    fi
}

function create_dummy_script()
#$1 full path of the script
#$2 name of the script
#$3 return value
{
    mkdir -p $1
    cat > $1/$2 << EOF
#!/bin/bash
$3
EOF
    chmod a+rwx $1/$2
    return 0
}

function create_dummy_file()
#same as at create_dummy_script
{
    mkdir -p $1
    cat > $1/$2 <<EOF
$3
EOF

    return 0
}
