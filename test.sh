# **************************************************************************** #
#                                                                              #
#                                                     .--.  _                  #
#    test.sh                                         |o_o || |                 #
#                                                    |:_/ || |_ _   ___  __    #
#    By: houtworm <codam@houtworm.net>              //   \ \ __| | | \ \/ /    #
#                                                  (|     | )|_| |_| |>  <     #
#    Created: 2023/02/20 12:46:49 by houtworm     /'\_   _/`\__|\__,_/_/\_\    #
#    Updated: 2023/03/01 17:06:54 by houtworm     \___)=(___/                  #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

OS=$(uname -s)
SLEEP=1
FAULTS=0
CATLOC=$(which cat)
mkdir -p tmp
echo "Hallo\nHallo\nHallo" > tmp/input
touch tmp/perm tmp/cmd
chmod 000 tmp/perm
echo cat > tmp/cmd
if [ $1 ]
then
	SLEEP=$1
fi

checkfile()
{
	ls $1 2> /dev/null | grep $1 > /dev/null
	if [ $? -ne $2 ]
	then
		printf "\e[1;31mMakefile does not create $1\e[0;00m\n"
		rm -rf tmp/files
		exit 1
	fi
}

searchobj()
{
	FILES=$(find ./ -name '*.o' | wc -l)
	if [ $1 -eq 0 ]
	then
		if [ $FILES -ne 0 ]
		then
			printf "\e[1;31mObject files found after clean\e[0;00m\n"
			FAULTS=$(($FAULTS+1))
		fi
	fi
	if [ $1 -eq 1 ]
	then
		if [ $FILES -eq 0 ]
		then
			printf "\e[1;31mObject files not found after make\e[0;00m\n"
			FAULTS=$(($FAULTS+1))
		fi
	fi
}

checkrule()
{
	make $1 > /dev/null 2>&1
	if [ $? -eq 2 ]
	then
		printf "\e[1;31mMissing rule $1\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

errorpermdenied()
{
	ERRMSG=$(cat tmp/error | grep "mission denied" | wc -l)
	if [ $ERRMSG -eq $1 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong Error Message \e[0;00m\n"
		cat tmp/error
		FAULTS=$(($FAULTS+1))
	fi
}

errorfiledescri()
{
	ERRMSG=$(cat tmp/error | grep "file descri" | wc -l)
	if [ $ERRMSG -eq $1 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong Error Message\e[0;00m\n"
		cat tmp/error
		FAULTS=$(($FAULTS+1))
	fi
}

errornotfound()
{
	ERRMSG=$(cat tmp/error | grep "not found" | wc -l)
	if [ $ERRMSG -eq $1 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong Error Message\e[0;00m\n"
		cat tmp/error
		FAULTS=$(($FAULTS+1))
	fi
}

errorinvalid()
{
	ERRMSG=$(cat tmp/error | grep "option --" | wc -l)
	if [ $ERRMSG -eq $1 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong Error Message\e[0;00m\n"
		cat tmp/error
		FAULTS=$(($FAULTS+1))
	fi
}

errorsuchfile()
{
	ERRMSG=$(cat tmp/error | grep "such file" | wc -l)
	if [ $ERRMSG -eq $1 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong Error Message\e[0;00m\n"
		cat tmp/error
		FAULTS=$(($FAULTS+1))
	fi
}

errorclean()
{
	ERRMSG=$(cat tmp/error | grep " " | wc -l)
	if [ $ERRMSG -eq 0 ]
	then
		printf "\e[1;32mError Message OK\e[0;00m\n"
	else
		printf "\e[1;31mPrinted Error Message\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

fourargs()
{
	./pipex $1 "$2" "$3" $4 2> tmp/error
	RTRN=$?
	< $1 $2 2> /dev/null | $3 > tmp/expected 2> /dev/null
	if [ $? -eq $RTRN ]
	then
		printf "\e[1;32mReturn value OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
	diff $4 tmp/expected
	if [ $? -eq 0 ]
	then
		printf "\e[1;32mOutput file OK\e[0;00m\n"
	else
		printf "\e[1;31mOutput files don't match\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

fournodiff()
{
	timeout 2 ./pipex $1 "$2" "$3" $4 2> tmp/error
	RTRN=$?
	< $1 $2 2> /dev/null | $3 > tmp/expected 2> /dev/null
	if [ $? -eq $RTRN ]
	then
		printf "\e[1;32mEndless command OK\e[0;00m\n"
	else
		printf "\e[1;31mYour pipex hangs forever\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

fiveargs()
{
	./pipex $1 "$2" "$3" "$4" $5 2> tmp/error
	RTRN=$?
	< $1 $2 2> /dev/null | $3 2> /dev/null | $4 > tmp/expected 2> /dev/null
	if [ $? -eq $RTRN ]
	then
		printf "\e[1;32mEndless command OK\e[0;00m\n"
	else
		printf "\e[1;31mOutput files don't match\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
	diff $5 tmp/expected
	if [ $? -eq 0 ]
	then
		printf "\e[1;32mOutput file OK\e[0;00m\n"
	else
		printf "\e[1;31mOutput files don't match\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

fivenodiff()
{
	timeout 2 ./pipex $1 "$2" "$3" "$4" $5 2> tmp/error
	RTRN=$?
	< $1 $2 2> /dev/null | $3 2> /dev/null | $4 > tmp/expected 2> /dev/null
	if [ $? -eq $RTRN ]
	then
		printf "\e[1;32mReturn value OK\e[0;00m\n"
	else
		printf "\e[1;31mYour pipex hangs forever\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

wrongarg()
{
	./pipex $2 $3 $4 $5 $6 $7
	RTRN=$?
	if [ $1 -eq $RTRN ]
	then
		printf "\e[1;32mReturn value OK\e[0;00m\n"
	else
		printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
}

# Test 1
printf "\e[1;36mTest 1: Checking all source with Norminette\e[0;00m\n"
norminette > /dev/null 2>&1
if [ $? -eq 1 ]
then
	printf "\e[1;31mYour shit is not norm!\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
else
	printf "\e[1;32mNorminette OK\e[0;00m\n"
fi
sleep $SLEEP

# Test 2
printf "\e[1;36mTest 2: Checking all mandatory rules Makefile\e[0;00m\n"
checkrule all
checkfile pipex 0
searchobj 1
checkrule clean
searchobj 0
checkfile pipex 0
checkrule pipex
checkfile pipex 0
searchobj 1
checkrule fclean
searchobj 0
checkfile pipex 1
checkrule re
searchobj 1
checkfile pipex 0
if [ $FAULTS -eq 0 ]
then
	printf "\e[1;32mMakefile rules OK\e[0;00m\n"
fi
sleep $SLEEP

# Test 3
printf "\e[1;36mTest 3: Checking if Makefile relinks\e[0;00m\n"
make 2>&1 | grep Nothing
if [ $? -eq 1 ]
then
	printf "\e[1;31mMakefile relinks\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
else
	printf "\e[1;32mMakefile OK\e[0;00m\n"
fi
sleep $SLEEP

# Test 4
printf "\e[1;36mTest 4: Running pipex with no arguments\e[0;00m\n"
wrongarg 1
sleep $SLEEP

# Test 5
printf "\e[1;36mTest 5: Running pipex with 1 argument\e[0;00m\n"
wrongarg 1 1
sleep $SLEEP

# Test 6
printf "\e[1;36mTest 6: Running pipex with 2 arguments\e[0;00m\n"
wrongarg 1 1 2
sleep $SLEEP

# Test 7
printf "\e[1;36mTest 7: Running pipex with 3 arguments\e[0;00m\n"
wrongarg 1 1 2 3
sleep $SLEEP

# Test 8
printf "\e[1;36mTest 8: Running pipex with 5 arguments\e[0;00m\n"
wrongarg 1 1 2 3 4 5
sleep $SLEEP

# Test 9
printf "\e[1;36mTest 9: Running pipex with 6 arguments\e[0;00m\n"
wrongarg 1 1 2 3 4 5 6
sleep $SLEEP

# Test 10
printf "\e[1;36mTest 10: Running pipex properly with basic commands\e[0;00m\n"
fourargs tmp/input "cat" "cat" tmp/output
errorclean
sleep $SLEEP

# Test 11
printf "\e[1;36mTest 11: Running pipex with commands with options\e[0;00m\n"
fourargs tmp/input "cat -e" "cat -v" tmp/output
errorclean
sleep $SLEEP

# Test 12
printf "\e[1;36mTest 12: Running pipex with commands with multiple options\e[0;00m\n"
fourargs tmp/input "cat -u -v -e" "cat -v -b -e" tmp/output
errorclean
sleep $SLEEP

# Test 13
printf "\e[1;36mTest 13: Running pipex with empty commands\e[0;00m\n"
./pipex tmp/input "" "" tmp/output 2> tmp/error
< tmp/input "" 2> /dev/null | "" > tmp/expected 2> /dev/null
if [ $? -eq 127 ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 127 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errornotfound 2
sleep $SLEEP

# Test 14
printf "\e[1;36mTest 14: Running pipex with space commands\e[0;00m\n"
./pipex tmp/input " " " " tmp/output 2> tmp/error
RTRN=$?
< tmp/input " " 2> /dev/null | " " > tmp/expected 2> /dev/null
if [ 127 -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 127 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errornotfound 2
sleep $SLEEP

# Test 15
printf "\e[1;36mTest 15: Running pipex with backticks\e[0;00m\n"
./pipex tmp/input "`cat tmp/cmd`" "`echo cat`" tmp/output 2> tmp/error
if [ $? -eq 0 ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 0 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
< tmp/input `cat tmp/cmd` 2> /dev/null | `echo cat` > tmp/expected 2> /dev/null
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorclean
sleep $SLEEP

# Test 16
printf "\e[1;36mTest 16: Running pipex with \$()\e[0;00m\n"
fourargs tmp/input "$(cat tmp/cmd)" "$(echo cat)" tmp/output
errorclean
sleep $SLEEP

# Test 17
printf "\e[1;36mTest 17: Running pipex with non existing input\e[0;00m\n"
fourargs doesnotexist "cat" "cat" tmp/output
errorsuchfile 1
sleep $SLEEP

# Test 18
printf "\e[1;36mTest 18: Running pipex with nonexisting command 1\e[0;00m\n"
fourargs tmp/input "doesnotexist" "cat" tmp/output
errornotfound 1
sleep $SLEEP

# Test 19
printf "\e[1;36mTest 19: Running pipex with nonexisting command 2\e[0;00m\n"
fourargs tmp/input "cat" "doesnotexist" tmp/output
errornotfound 1
sleep $SLEEP

# Test 20
printf "\e[1;36mTest 20: Running pipex with nonexisting command 1 & 2\e[0;00m\n"
fourargs tmp/input "doesnotexist" "doesnotexist" tmp/output
errornotfound 2
sleep $SLEEP

# Test 21
printf "\e[1;36mTest 21: Running pipex with nonexisting input and command 1 \e[0;00m\n"
fourargs doesnotexist "doesnotexist" "cat" tmp/output
errorsuchfile 1
sleep $SLEEP

# Test 22
printf "\e[1;36mTest 22: Running pipex with nonexisting option 1\e[0;00m\n"
fourargs tmp/input "cat -r" "cat" tmp/output
errorinvalid 1
sleep $SLEEP

# Test 23
printf "\e[1;36mTest 23: Running pipex with nonexisting option command 2\e[0;00m\n"
fourargs tmp/input "cat" "cat -r" tmp/output
errorinvalid 1
sleep $SLEEP

# Test 24
printf "\e[1;36mTest 24: Running pipex with nonexisting option command 1 & 2\e[0;00m\n"
fourargs tmp/input "cat -r" "cat -r" tmp/output
errorinvalid 2
sleep $SLEEP

# Test 25
printf "\e[1;36mTest 25: Running pipex with no read permissions on input\e[0;00m\n"
fourargs tmp/perm "cat" "cat" tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 26
printf "\e[1;36mTest 26: Running pipex with no write permissions on existing output\e[0;00m\n"
./pipex tmp/input "cat" "cat" tmp/perm 2> tmp/error
RTRN=$?
< tmp/input "cat" 2> /dev/null | "cat" > tmp/perm 2> /dev/null
if [ $? -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorpermdenied 1
sleep $SLEEP

# Test 27
printf "\e[1;36mTest 27: Running pipex with no execute permissions on command 1\e[0;00m\n"
fourargs tmp/input tmp/perm cat tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 28
printf "\e[1;36mTest 28: Running pipex with no execute permissions on command 2\e[0;00m\n"
fourargs tmp/input cat tmp/perm tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 29
printf "\e[1;36mTest 29: Running pipex with no execute permissions on command 1 & 2\e[0;00m\n"
fourargs tmp/input tmp/perm tmp/perm tmp/output
errorpermdenied 2
sleep $SLEEP

# Test 30
printf "\e[1;36mTest 30: Running pipex with no execute permissions on command 1 and input\e[0;00m\n"
fourargs tmp/perm tmp/perm cat tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 31
printf "\e[1;36mTest 31: Running pipex with no execute permissions on command 2 and input\e[0;00m\n"
fourargs tmp/perm cat tmp/perm tmp/output
errorpermdenied 2
sleep $SLEEP

# Test 32
printf "\e[1;36mTest 32: Running pipex without the PATH env variable\e[0;00m\n"
export ATH=$PATH
unset PATH
./pipex tmp/input "cat" "cat" tmp/output 2> tmp/error
< tmp/input cat 2> /dev/null | cat > tmp/expected 2> /dev/null
if [ $? -eq 127 ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 127 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
export PATH=$ATH
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorsuchfile 2
sleep $SLEEP

# Test 33
printf "\e[1;36mTest 33: Running pipex with double quotes\e[0;00m\n"
fourargs tmp/input "echo ""hallo hallo"""  "echo ""hallo hallo""" tmp/output
errorclean
sleep $SLEEP

# Test 34
printf "\e[1;36mTest 34: Running pipex with single quotes\e[0;00m\n"
fourargs tmp/input 'echo ''hallo hallo''' 'echo ''hallo hallo''' tmp/output
errorclean
sleep $SLEEP

# Test 35
printf "\e[1;36mTest 35: Running pipex with double quotes in single quotes\e[0;00m\n"
fourargs tmp/input 'echo "hallo hallo"' 'echo "hallo hallo"' tmp/output
errorclean
sleep $SLEEP

# Test 36
printf "\e[1;36mTest 36: Running pipex with single quotes in double quotes\e[0;00m\n"
fourargs tmp/input "echo 'hallo hallo'" "echo 'hallo hallo'" tmp/output
errorclean
sleep $SLEEP

# Test 37
printf "\e[1;36mTest 37: Running pipex with Absolute paths\e[0;00m\n"
fourargs tmp/input "$CATLOC" "$CATLOC" tmp/output
errorclean
sleep $SLEEP

# Test 38
cp $CATLOC tmp/cat
printf "\e[1;36mTest 38: Running pipex with Relative paths\e[0;00m\n"
fourargs tmp/input "tmp/cat" "tmp/cat" tmp/output
errorclean
sleep $SLEEP

# Test 39
printf "\e[1;36mTest 39: Running pipex here_doc as inputfile\e[0;00m\n"
fourargs here_doc "cat" "cat" tmp/output
errorsuchfile 1
sleep $SLEEP

# Test 40
printf "\e[1;36mTest 40: Running pipex with 2 sleep commands\e[0;00m\n"
(time < tmp/input sleep 1 | sleep 1 > tmp/expected) 2>&1 > /dev/null | grep real | awk '{print substr($0,6,4);}' > tmp/timereal
(time ./pipex tmp/input "sleep 1" "sleep 1" tmp/output) 2>&1 > /dev/null | grep real | awk '{print substr($0,6,4);}' > tmp/timepipe
diff tmp/timereal tmp/timepipe
if [ $? -eq 0 ]
then
	printf "\e[1;32mTime is OK\e[0;00m\n"
else
	printf "\e[1;31mPipes should all be executed at once\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
sleep $SLEEP

# Test 41
printf "\e[1;36mTest 41: Running pipex with an endless command\e[0;00m\n"
fournodiff tmp/input "cat /dev/random" "head -c 100" tmp/expected
errorclean
sleep $SLEEP

# Test 42
printf "\e[1;36mTest 42: Checking if Makefile bonus rule exists\e[0;00m\n"
make fclean > /dev/null
make bonus >/dev/null 2>&1
if [ $? -eq 2 ]
then
	printf "\e[1;31mNo bonus? I am a little dissapointed...\e[0;00m\n"
	if [ $FAULTS -eq 0 ]
	then
		printf "\e[1;35mBut we got no errors, Congratulations\e[0;00m\n"
		rm -rf tmp
		make fclean > /dev/null
		exit 0
	else
		printf "\e[1;31mAnd we got $FAULTS errors\nSo that's a bummer\e[0;00m\n"
		make fclean > /dev/null
		rm -rf tmp
		exit 1
	fi
fi
printf "\e[1;32mbonus rule OK\e[0;00m\n"
sleep $SLEEP

# Test 43
printf "\e[1;36mTest 43: Checking if Makefile relinks for bonus\e[0;00m\n"
make bonus 2>&1 | grep Nothing
if [ $? -eq 1 ]
then
	printf "\e[1;31mMakefile relinks on bonus\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
else
	printf "\e[1;32mMakefile bonus OK\e[0;00m\n"
fi
sleep $SLEEP

# Test 44
printf "\e[1;36mTest 44: Running pipex properly with basic commands\e[0;00m\n"
fiveargs tmp/input "cat" "cat" "cat" tmp/output
errorclean
sleep $SLEEP

# Test 45
printf "\e[1;36mTest 45: Running pipex with commands with options\e[0;00m\n"
fiveargs tmp/input "cat -e" "cat -b" "cat -v" tmp/output
errorclean
sleep $SLEEP

# Test 46
printf "\e[1;36mTest 46: Running pipex with commands with multiple options\e[0;00m\n"
fiveargs tmp/input "cat -u -b -e" "cat -v -b -e" "cat -v -b -e" tmp/output
errorclean
sleep $SLEEP

# Test 47
printf "\e[1;36mTest 47: Running pipex with empty commands\e[0;00m\n"
./pipex tmp/input "" "" "" tmp/output 2> tmp/error
if [ $? -eq 127 ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 127 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
< tmp/input "" 2> /dev/null | "" 2> /dev/null | "" > tmp/expected 2> /dev/null
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errornotfound 3
sleep $SLEEP

# Test 48
printf "\e[1;36mTest 48: Running pipex with space commands\e[0;00m\n"
./pipex tmp/input " " " " " " tmp/output 2> tmp/error
RTRN=$?
< tmp/input " " 2> /dev/null | " " 2> /dev/null | " " > tmp/expected 2> /dev/null
if [ 127 -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 127 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errornotfound 3
sleep $SLEEP

# Test 49
printf "\e[1;36mTest 49: Running pipex with double quotes\e[0;00m\n"
fiveargs tmp/input "echo ""hallo hallo"""  "echo ""hallo hallo""" "echo ""hallo hallo""" tmp/output
errorclean
sleep $SLEEP

# Test 50
printf "\e[1;36mTest 50: Running pipex with single quotes\e[0;00m\n"
fiveargs tmp/input 'echo ''hallo hallo''' 'echo ''hallo hallo''' 'echo ''hallo hallo''' tmp/output
errorclean
sleep $SLEEP

# Test 51
printf "\e[1;36mTest 51: Running pipex with double quotes in single quotes\e[0;00m\n"
fiveargs tmp/input 'echo "hallo hallo"' 'echo "hallo hallo"' 'echo "hallo hallo"' tmp/output
errorclean
sleep $SLEEP

# Test 52
printf "\e[1;36mTest 52: Running pipex with single quotes in double quotes\e[0;00m\n"
fiveargs tmp/input "echo 'hallo hallo'" "echo 'hallo hallo'" "echo 'hallo hallo'" tmp/output
errorclean
sleep $SLEEP

# Test 53
printf "\e[1;36mTest 53: Running pipex with Absolute paths\e[0;00m\n"
fiveargs tmp/input "$CATLOC" "$CATLOC" "$CATLOC" tmp/output
errorclean
sleep $SLEEP

# Test 54
cp $CATLOC tmp/cat
printf "\e[1;36mTest 54: Running pipex with Relative paths\e[0;00m\n"
fiveargs tmp/input "tmp/cat" "tmp/cat" "tmp/cat" tmp/output
errorclean
sleep $SLEEP

# Test 55
printf "\e[1;36mTest 55: Running pipex with backticks\e[0;00m\n"
./pipex tmp/input "`cat tmp/cmd`" "`echo cat`" "`cat tmp/cmd`" tmp/output 2> tmp/error
if [ $? -eq 0 ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be 0 is $?\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
< tmp/input `cat tmp/cmd` 2> /dev/null | `echo cat` > tmp/expected 2> /dev/null
diff tmp/output tmp/expected
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorclean
sleep $SLEEP

# Test 56
printf "\e[1;36mTest 56: Running pipex with \$()\e[0;00m\n"
fiveargs tmp/input "$(cat tmp/cmd)" "$(echo cat)" "$(cat tmp/cmd)" tmp/output
errorclean
sleep $SLEEP

# Test 57
printf "\e[1;36mTest 57: Running pipex with non existing input\e[0;00m\n"
fiveargs doesnotexist "cat" "cat" "cat" tmp/output
errorsuchfile 1
sleep $SLEEP

# Test 58
printf "\e[1;36mTest 58: Running pipex with nonexisting command 1\e[0;00m\n"
fiveargs tmp/input "doesnotexist" "cat" "cat" tmp/output
errornotfound 1
sleep $SLEEP

# Test 59
printf "\e[1;36mTest 59: Running pipex with nonexisting command 2\e[0;00m\n"
fiveargs tmp/input "cat" "doesnotexist" "cat" tmp/output
errornotfound 1
sleep $SLEEP

# Test 60
printf "\e[1;36mTest 60: Running pipex with nonexisting command 3\e[0;00m\n"
fiveargs tmp/input "cat" "cat" "doesnotexist" tmp/output
errornotfound 1
sleep $SLEEP

# Test 61
printf "\e[1;36mTest 61: Running pipex with nonexisting command 1, 2 & 3\e[0;00m\n"
fiveargs tmp/input "doesnotexist" "doesnotexist" "doesnotexist" tmp/output
errornotfound 3
sleep $SLEEP

# Test 62
printf "\e[1;36mTest 62: Running pipex with nonexisting input and command 1 \e[0;00m\n"
fiveargs doesnotexist "doesnotexist" "cat" "cat" tmp/output
errorsuchfile 1
sleep $SLEEP

# Test 63
printf "\e[1;36mTest 63: Running pipex with nonexisting option 1\e[0;00m\n"
fiveargs tmp/input "cat -r" "cat" "cat" tmp/output
errorinvalid 1
sleep $SLEEP

# Test 64
printf "\e[1;36mTest 64: Running pipex with nonexisting option command 3\e[0;00m\n"
fiveargs tmp/input "cat" "cat" "cat -r" tmp/output
errorinvalid 1
sleep $SLEEP

# Test 65
printf "\e[1;36mTest 65: Running pipex with nonexisting option command 1, 2 & 3\e[0;00m\n"
fiveargs tmp/input "cat -r" "cat -r" "cat -r" tmp/output
errorinvalid 3
sleep $SLEEP

# Test 66
printf "\e[1;36mTest 66: Running pipex with no read permissions on input\e[0;00m\n"
fiveargs tmp/perm "cat" "cat" "cat" tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 67
printf "\e[1;36mTest 67: Running pipex with no write permissions on existing output\e[0;00m\n"
./pipex tmp/input "cat" "cat" "cat" tmp/perm 2> tmp/error
RTRN=$?
< tmp/input "cat" 2> /dev/null | "cat" 2> /dev/null | "cat" > tmp/perm 2> /dev/null
if [ $? -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorpermdenied 1
sleep $SLEEP

# Test 68
printf "\e[1;36mTest 68: Running pipex with no execute permissions on command 1\e[0;00m\n"
fiveargs tmp/input tmp/perm cat cat tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 69
printf "\e[1;36mTest 69: Running pipex with no execute permissions on command 2\e[0;00m\n"
fiveargs tmp/input cat tmp/perm cat tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 70
printf "\e[1;36mTest 70: Running pipex with no execute permissions on command 3\e[0;00m\n"
fiveargs tmp/input cat cat tmp/perm tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 71
printf "\e[1;36mTest 71: Running pipex with no execute permissions on command 1, 2 & 3\e[0;00m\n"
fiveargs tmp/input tmp/perm tmp/perm tmp/perm tmp/output
errorpermdenied 3
sleep $SLEEP

# Test 72
printf "\e[1;36mTest 72: Running pipex with no execute permissions on command 1 and input\e[0;00m\n"
fiveargs tmp/perm tmp/perm cat cat tmp/output
errorpermdenied 1
sleep $SLEEP

# Test 73
printf "\e[1;36mTest 73: Running pipex with no execute permissions on command 3 and input\e[0;00m\n"
fiveargs tmp/perm cat cat tmp/perm tmp/output
errorpermdenied 2
sleep $SLEEP

# Test 74
printf "\e[1;36mTest 74: Running pipex with heredoc empty lines\e[0;00m\n"
printf "press enter twice, type EOF and press enter again\n"
./pipex here_doc EOF "cat" "cat" tmp/output 2> tmp/error
RTRN=$?
<< EOF cat 2> /dev/null | cat >> tmp/expected 2> /dev/null


EOF
if [ $? -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected > /dev/null 2>&1
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorclean
sleep $SLEEP

# Test 75
printf "\e[1;36mTest 75: Running pipex with heredoc space before and after delimiter\e[0;00m\n"
printf "type ' EOF', press enter, type 'EOF', press enter again. without quotes, and notice the spaces\n"
./pipex here_doc EOF "cat" "cat" tmp/output 2> tmp/error
RTRN=$?
<< EOF cat 2> /dev/null | cat >> tmp/expected 2> /dev/null
 EOF
EOF
if [ $? -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected > /dev/null 2>&1
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorclean
printf "\e[1;35mNote that we can't test 'EOF ' from this script, test it and huge lines to be sure\e[0;00m\n"
sleep $SLEEP

# Test 76
printf "\e[1;36mTest 76: Running pipex with well over a thousand pipes\e[0;00m\n"
if [ $OS == "Linux" ]
then
	printf "\e[1;35mNote that this can have unpredictable behavior\e[0;00m\n"
		./pipex tmp/input cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat cat tmp/output 2> /dev/null
	RTRN=$?
	< tmp/input cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat | cat > tmp/expected 2> /dev/null
	if [ $? -eq $RTRN ]
	then
		printf "\e[1;32mReturn value OK\e[0;00m\n"
	else
		printf ""
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
	diff tmp/output tmp/expected > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		printf "\e[1;32mOutput file OK\e[0;00m\n"
	else
		printf "\e[1;31mOutput files don't match\e[0;00m\n"
		FAULTS=$(($FAULTS+1))
	fi
	errorfiledescri 1
else
	printf "\e[1;35mSkipping.... Test crashes the tester on $OS\e[0;00m\n"
fi
sleep $SLEEP

# Test 77
printf "\e[1;36mTest 77: Running pipex with all wrong options except the last\e[0;00m\n"
./pipex tmp/input "cat -r" "cat -r" "cat -r" "cat -r" "cat -r" "cat -r" "cat -r" "cat -r" "cat -r" cat tmp/output 2> tmp/error
RTRN=$?
< tmp/input cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat -r 2> /dev/null | cat > tmp/expected 2> /dev/null
if [ $? -eq $RTRN ]
then
	printf "\e[1;32mReturn value OK\e[0;00m\n"
else
	printf "\e[1;31mWrong return value should be $? is $RTRN\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
diff tmp/output tmp/expected > /dev/null 2>&1
if [ $? -eq 0 ]
then
	printf "\e[1;32mOutput file OK\e[0;00m\n"
else
	printf "\e[1;31mOutput files don't match\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
errorinvalid 9
sleep $SLEEP

# Test 78
printf "\e[1;36mTest 78: Running pipex with 3 sleep commands\e[0;00m\n"
(time < tmp/input sleep 1 | sleep 1 > tmp/expected) 2>&1 > /dev/null | grep real | awk '{print substr($0,6,4);}' > tmp/timereal
(time ./pipex tmp/input "sleep 1" "sleep 1" tmp/output) 2>&1 > /dev/null | grep real | awk '{print substr($0,6,4);}' > tmp/timepipe
diff tmp/timereal tmp/timepipe
if [ $? -eq 0 ]
then
	printf "\e[1;32mTime is OK\e[0;00m\n"
else
	printf "\e[1;31mPipes should all be executed at once\e[0;00m\n"
	FAULTS=$(($FAULTS+1))
fi
sleep $SLEEP

# Test 79
printf "\e[1;36mTest 79: Running pipex with an endless command\e[0;00m\n"
fivenodiff tmp/input "cat /dev/random" "base64" "head -c 100" tmp/expected
errorclean
sleep $SLEEP

if [ $FAULTS -eq 0 ]
then
	printf "\e[1;35mwe got no errors, Congratulations\e[0;00m\n"
else
	printf "\e[1;31mwe got $FAULTS errors\nSo that's a bummer\e[0;00m\n"
	rm -rf tmp
	make fclean > /dev/null
	exit 1
fi
rm -rf tmp
make fclean > /dev/null
exit 0
