#!/bin/bash

source /shu_inc/unit_test.sh
source /shu_inc/globals.sh
source /main.sh

TESTSET "001"

TEST 'print_out_test' \
     'print_out' \
     'NO_FORK' \
      10 

ASSERT_NO_ERROR
ASSERT_OUTPUT "^test this function$"
ASSERT_EQ 123 ${APPLE} 
ASSERT_RETURN 10

TESTSET_END
