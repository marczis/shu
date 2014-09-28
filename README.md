shu
===

Shell Unit Testing framework

Hello, so you're interested in running unit testcases in shell :)
I did this to make my life easier and now I'm ready to share it...
Sorry, but the documenation won't be so good now, as I have a lots 
of thing to handle, but as soon as anyone gets interested in it, I
promise to write a detailed one. Right now I will just put here some
installation details...

So installation steps:

#1 Get the source into a directory (any)
#2 go into include subdirectory and copy globals.sh
#3 edit the file, change at least this one line:
DIR_SHU_TEST_ROOT='${HOME}/pro/shu'

#4 add $DIR_SHU_TEST_ROOT/bin to your path !

#5 to test if everything is okay go into the example directory and run shu_run.sh

The expected outcome is something like this:

shu_run.sh 
NOTE: There is no /home/marczis/pro/shu/example/utest/test_env
PRE SCRIPT


==========================================================
 SET: 001
==========================================================
|....

__________________________________________________________
 Every test passed.


==========================================================
==========================================================
 TESTSETS: 1                                
 PASSED  : 1                            
 FAILED  : 0                            
==========================================================
                All tests are PASSED                      
==========================================================


Some final toughts:
 - I'm happy to give support if you need it. (but you have to find me :)
 - I take no responsibility for any damage you make...
 - As the tool is in a very early test phase for the mass, you may face terrible prints and strange errors... please report those
 - As I don't have a detailed documentation the best source to check is the example. and the source of course, you
 may figured out already, its in pure bash :) 
 
 Things you will still need aka pre-requirements:
  - sudo (without password, sorry taff thing I know, you may try with password, I never did)
  - chroot
  - x86_64 or you have to link your x86 things into the test_env_common (yeah those things are copied into a chroot, use only symlinks there)
  - in additional_env_tools you can put extra things (those will be copied too into the chroot)
  - and as you figured out at this part, the whole thing works in a chroot, to save your own system from the destructive scripts you will test with SHU
  
I hope it will serve you as well as served me :)
