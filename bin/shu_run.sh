#!/bin/bash


#$1 - the directory of TCs, if not given pwd will be used

if [ -z $1 ] ; then
    SOURCE=`pwd`
else
    SOURCE=$1
fi

#Get globals
source globals.sh

#Remove temp
sudo rm -fr ${DIR_TEST_ENV_TMP}

#Create the temp directory for chroot
mkdir -p ${DIR_TEST_ENV_TMP} &> /dev/null
CHK_RES "Can't create ${DIR_TEST_ENV_TMP} for test" 1

#Copy common environment
cp -rL ${DIR_COMMON_ENV}/* ${DIR_TEST_ENV_TMP}
CHK_RES "Can't copy common environment from ${DIR_COMMON_ENV} to ${DIR_TEST_ENV_TMP}" 1

#Create Device dir
mkdir -p ${DIR_TEST_ENV_TMP}/dev

#Create NULL Device
sudo mknod ${DIR_TEST_ENV_TMP}/dev/null c 1 3 -m a=rw

#Copy TestSet environment
if [ -e ${SOURCE}/${DIR_TC}/${DIR_TS_ENV} ] ; then
    cp -rL ${SOURCE}/${DIR_TC}/${DIR_TS_ENV}/* ${DIR_TEST_ENV_TMP} &> /dev/null
else
    echo "NOTE: There is no ${SOURCE}/${DIR_TC}/${DIR_TS_ENV}"
fi

#Copy include
cp -rL ${DIR_SHU_TEST_ROOT}/include ${DIR_TEST_ENV_TMP}/shu_inc #Yes hardcoded !
CHK_RES "Can't copy include" 1

#Create /tmp on target
mkdir ${DIR_TEST_ENV_TMP}/tmp
CHK_RES "Can't create ${DIR_TEST_ENV_TMP}/tmp" 1
chmod a+rwx ${DIR_TEST_ENV_TMP}/tmp
CHK_RES "Can't set a+rwx on ${DIR_TEST_ENV_TMP}/tmp" 1

#Copy common scripts to include
if [ -e ${SOURCE}/${DIR_TC}/${DIR_COMMON_SCRIPTS} ] ; then
    cp -rL ${SOURCE}/${DIR_TC}/${DIR_COMMON_SCRIPTS}/ ${DIR_TEST_ENV_TMP}/shu_inc
else
    echo "NOTE: There is no ${SOURCE}/${DIR_TC}/${DIR_COMMON_SCRIPTS}"
fi

#Call pre script
if [ -e ${SOURCE}/${DIR_TC}/${DIR_COMMON_SCRIPTS}/${NAME_PRE_SCRIPT} ] ; then
    source ${SOURCE}/${DIR_TC}/${DIR_COMMON_SCRIPTS}/${NAME_PRE_SCRIPT}
    CHK_RES "Common PreScript FAILED." 1
else
    echo "NOTE: There is no ${SOURCE}/${DIR_TC}/${NAME_PRE_SCRIPT}"
fi

#Generate list of TCs
TCS=`ls ${SOURCE}/${DIR_TC}/ | grep -v "${NAME_PRE_SCRIPT}\|${NAME_POST_SCRIPT}\|${DIR_COMMON_SCRIPTS}\|${DIR_TS_ENV}"`

#Create TC dir on target
mkdir -p ${DIR_TEST_ENV_TMP}/${DIR_TC} &> /dev/null
CHK_RES "Can't create ${DIR_TEST_ENV_TMP}/${DIR_TC}" 1

#Copy them to target
for i in ${TCS}
do
    cp -rL ${SOURCE}/${DIR_TC}/${i} ${DIR_TEST_ENV_TMP}/${DIR_TC}
    CHK_RES "Can't copy ${SOURCE}/${DIR_TC}/${i} to ${DIR_TEST_ENV_TMP}/${DIR_TC}" 1
done

#Create chroot, and call TCs
test_set_cnt=0
failed_test_sets=0
passed_test_sets=0
for i in ${TCS}
do
    let 'test_set_cnt+=1'
    sudo chroot ${DIR_TEST_ENV_TMP} /${DIR_TC}/${i}/${NAME_START_TEST_SCRIPT}
    if [ $? != 0 ] ; then
        let 'failed_test_sets+=1'
    else
        let 'passed_test_sets+=1'
    fi
done

echo ; echo
echo "=========================================================="
echo "=========================================================="
echo " TESTSETS: ${test_set_cnt}                                "
echo " PASSED  : ${passed_test_sets}                            "
echo " FAILED  : ${failed_test_sets}                            "
echo "=========================================================="
if [ ${failed_test_sets} == 0 ] ; then
    echo "                All tests are PASSED                      "
else
    echo "              There were FAILED cases                     "
fi
echo "=========================================================="

