#!/bin/bash
#
# Copyright 2017 Chew, Kean Ho <kean.ho.chew@zoralab.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

################################################################################
# General Variables
################################################################################
export SOFTWARE_NAME="BaSHELL"
export SOFTWARE_DESCRIPTION="finally you can test bash script."
export VERSION="1.0.2"
export CURRENT_DIRECTORY=$(pwd)
export TEST_DIRECTORY="$CURRENT_DIRECTORY/tests"
export TEST_SCRIPT_DIRECTORY="$TEST_DIRECTORY/scripts"
export TEST_TEMP_DIRECTORY="$TEST_DIRECTORY/temp"
export TEST_PASS=0
export TEST_SKIP=1
export TEST_FAIL=2

if [[ ! -n "${TERM+set}" ]]; then
	export TERM="xterm-256color"
fi

################################################################################
# ERROR_CODES
################################################################################
ERROR_ARGUMENT=1
ERROR_MISSING_FILE=2
ERROR_UNKNOWN_PATH=3
ERROR_ITEM_EXIST=4
ERROR_SYMLINK_PATH=5
ERROR_NOT_INSTALLED=6
ERROR_FILE_EXISTS=7
ERROR_INVALID_WORKSPACE=8

print_error_messages() {
	echo -n "error: "
	case "$1" in
		1|-a|--unknownArg)
			echo -n "Unknown arguments."
			;;
		-v|--unknownValue)
			echo -n "Unknown VALUE."
			;;
		3|-f|--unknownFilepath)
			echo -n "Unknown FILEPATH."
			;;
		-mTST|--missingTestScriptTemplate)
			echo -n "found TEST_SCRIPT_TEMPLATE_PATH declared but "
			echo -n "file not exist at $TEST_SCRIPT_TEMPLATE_PATH."
			;;
		6|-i|--notInstalled)
			echo -n "BaSHELL Framework not found. "
			;;
		7|-e|--fileExists)
			echo -n "File already exists!"
			;;
		8|-n|--invalidWorkspace)
			echo -n "Invalid Workspace. Are you in the workspace "
			echo -n "root directory?"
			;;
		*)
			echo -n "Unknown error."
			;;
	esac
	echo " Try 'bashell -h' for help."
}

################################################################################
# Codes
################################################################################
tprint_horizontal_line() {
	if [[ $1 != '' ]]; then
		printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' $1
	else
		printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
	fi
}
export -f tprint_horizontal_line

tprint() {
	echo "NOTE: $@"
	return 0
}
export -f tprint

tprint_test_description() {
	tprint_horizontal_line
	echo -e "TEST TITLE: "$1
	echo -e "TEST FOR:" $2
	echo -e "DESCRIPTION: "$3
	tprint_horizontal_line
}
export -f tprint_test_description

verdict() {
	case "$1" in
		-p|--passed)
			condition="PASSED"
			;;
		-f|--failed)
			condition="FAILED"
			;;
		-s|--skipped)
			condition="SKIPPED"
			;;
		*)
			condition="ERROR - do either '-p', '-f' or '-s'"
			;;
	esac
	shift 1
	message=$@
	if [[ ${#message} != 0 ]]; then
		echo "[ $condition ] "$1
	else
		echo "[ $condition ]"
	fi
	unset message
}
export -f verdict

detect_valid_directory() {
	if [[ -d "$1" ]]; then
		if [[ -L "$1" ]]; then
			return 2
		fi
		return 0
	fi
	return 1
}

create_test_script() {
	if [[ "$1" = "" ]]; then
		return $ERROR_ARGUMENT
	fi
	location=$1
	suite=${location%/*}
	suite=${suite#$TEST_SCRIPT_DIRECTORY\/}
	title=${1##*/}
	title=${title%.test}
	title=$(tr -s '_' ' ' <<< "$title")
	echo "#!/bin/bash
TITLE=\"$title\"
SUITE=\"$suite\"
DESCRIPTION=\"\n \\
Give a short description about your test
\"
tprint_test_description \"\$TITLE\" \"\$SUITE\" \"\$DESCRIPTION\"
################################################################################

DEMO=\"pass\"

if [[ \"\$DEMO\" == \"fail\" ]]; then
	verdict --failed \"test failed message\"
	exit \$TEST_FAIL
fi

if [[ \"\$DEMO\" == \"skip\" ]]; then
	verdict --skipped \"skip test message\"
	exit \$TEST_SKIP
fi

verdict --passed
exit \$TEST_PASS
" >> "$location"
}

run_help() {
	echo "$SOFTWARE_NAME - $SOFTWARE_DESCRIPTION"
	echo ""
	echo "$0 [options] [value] [options] [value] ..."
	echo ""
	echo "Available options:"
	echo "-h, --help                     show help page."
	echo ""
	echo "-c, --create VALUE             create an object. VALUE can be:"
	echo "    VALUE: framework              1) The BaSHELL framework."
	echo "    VALUE: script FILEPATH        2) A test script with FILEPATH."
	echo "                                     E.g.: 'directory/name' for"
	echo "                                     'directory/name.test'."
	echo "                                     NOTE: make sure it doesn't"
	echo "                                     exist otherwise, it will"
	echo "                                     fail."
	echo ""
	echo "-d, --delete VALUE             delete an object. VALUE can be:"
	echo "    VALUE: framework              1) The BaSHELL framework."
	echo "    VALUE: script FILEPATH        2) A test script in FILEPATH."
	echo "                                     E.g.: 'directory/name' for"
	echo "                                     'directory/name.test'."
	echo "                                     NOTE: if the test folder"
	echo "                                     is empty, command will"
	echo "                                     remove that folder."
	echo ""
	echo "-r, --run VALUE                execute all tests run."
	echo "    no VALUE                     1) execute all tests (default)."
	echo "    VALUE: FILEPATH              3) run a particular test"
	echo "                                    located in the FILEPATH."
	echo "                                    E.g.: 'directory/name' for"
	echo "                                    'directory/name.test'."
	echo ""
	echo "-i, --install                  install BaSHELL framework."
	echo ""
	echo "-u, --uninstall                uninstall BaSHELL Framework."
	return 0
}

run_create_framework() {
	detect_valid_directory $TEST_DIRECTORY
	ret=$?
	if [[ $ret == 0 ]]; then
		1>&2 echo "ERROR: the test framework is already available."
		return $ERROR_ITEM_EXIST
	elif [[ $ret == 2 ]]; then
		1>&2 echo -n "NOTE: the test framework is a symlink. It won't "
		1>&2 echo "work properly."
		return $ERROR_SYMLINK_PATH
	fi
	mkdir $TEST_DIRECTORY
	mkdir $TEST_SCRIPT_DIRECTORY
	mkdir $TEST_TEMP_DIRECTORY
	touch "$TEST_DIRECTORY/.gitkeep"
	touch "$TEST_SCRIPT_DIRECTORY/.gitkeep"
	touch "$TEST_TEMP_DIRECTORY/.gitkeep"
	ret=$BASH_SOURCE
	if [[ "$ret" != "" ]]; then
		cp -f "$ret" "$CURRENT_DIRECTORY/bashell.sh"
	fi
}

run_delete_framework() {
	detect_valid_directory $TEST_DIRECTORY
	ret=$?
	if [[ $ret == 0 ]]; then
		1>&2 echo -n "WARNING: this will delete all the items inside "
		1>&2 echo "/tests folder. ARE YOU SURE:"
		select yn in "YES" "No"; do
			case $yn in
				YES)
					rm -rf "$TEST_DIRECTORY" &> /dev/null
					rm "$CURRENT_DIRECTORY/bashell.sh" &> /dev/null
					return 0
					;;
				No)
					return 0
					;;
			esac
		done
	fi
}

process_test_script_path() {
	if [[ "$1" == "" ]]; then
		print_error_messages --unknownFilepath
		return $ERROR_UNKNOWN_PATH
	fi

	# check if there is a working directory
	detect_valid_directory $TEST_SCRIPT_DIRECTORY
	ret=$?
	if [[ $ret != 0 ]]; then
		print_error_messages --notInstalled
		return $ERROR_NOT_INSTALLED
	fi

	# prepare filepath and filename
	directory=${1%/*}
	filename=${1##*/}

	if [[ "$directory" == "$filename" ]]; then
		directory=""
	fi

	if [[ "$filename" != *".test"* ]]; then
		filename="$filename.test"
	fi

	if [[ "$directory" == "" ]]; then
		location="$TEST_SCRIPT_DIRECTORY/$filename"
	else
		location="$TEST_SCRIPT_DIRECTORY/$directory/$filename"
	fi
	unset filename
	unset directory

	echo $location
	return 0
}

run_create_test_script() {
	fullpath=$(process_test_script_path $1)
	ret=$?
	if [[ $ret != 0 ]]; then
		return $ret
	fi

	# get the test script template if provided
	if [[ $TEST_SCRIPT_TEMPLATE_PATH != "" ]]; then
		if [[ ! -f $TEST_SCRIPT_TEMPLATE_PATH ]]; then
			print_error_messages --missingTestScriptTemplate
			return $ERORR_MISSING_FILE
		fi
		template_path="$TEST_SCRIPT_TEMPLATE_PATH"
	fi

	# check if the script already exists
	if [[ -f "$fullpath" ]]; then
		print_error_messages --fileExists
		return $ERROR_FILE_EXISTS
	fi

	# create test directory regardless
	directory=$(dirname "$fullpath")
	if [[ "$directory" != "" ]]; then
		mkdir -p $directory
	fi

	# create test script
	if [[ "$template_path" != "" ]]; then
		cp $template_path $fullpath
	else
		create_test_script $fullpath
	fi

	# grant execution permission
	chmod +x $fullpath
}

run_delete_test_script() {
	fullpath=$(process_test_script_path $1)
	ret=$?
	if [[ $ret != 0 ]]; then
		return $ret
	fi

	rm $fullpath &> /dev/null
	directory=$(dirname "$fullpath")

	if [[ -d $directory &&
		$(find "$directory" -mindepth 1 -print -quit) == "" ]]; then
		rm -rf $directory
	fi
}

run_tests() {
	# detect if it is a vaild direct test framework
	detect_valid_directory $TEST_SCRIPT_DIRECTORY
	ret=$?
	if [[ $ret != 0 ]]; then
		print_error_messages --invalidWorkspace
		return $ERROR_INVALID_WORKSPACE
	fi

	# set test run mode
	export BASHELL_TEST_ENVIRONMENT=true

	# check if it is requesting to run single test
	if [[ $1 != "" ]]; then
		if [[ $1 == "tests"* ]]; then
			fullpath=$1
			if [[ ! -f "$fullpath" ]]; then
				print_error_messages --unknownFilepath
				return $ERROR_UNKNOWN_PATH
			fi
		else
			fullpath=$(process_test_script_path $1)
			ret=$?
			if [[ $ret != 0 ]]; then
				print_error_messages --unknownFilepath
				return $ERROR_UNKNOWN_PATH
			fi
		fi
		bash $fullpath
		rm -rf $TEST_TEMP_DIRECTORY/*
		return 0
	fi

	# setup banner
	echo "---------------------------------------"
	echo "| Resources Collection Test Framework |"
	echo "---------------------------------------"
	echo "Build for testing assets and scripts."

	# get all test scripts
	list=($(find $TEST_SCRIPT_DIRECTORY -type f -name "*.test"))
	total_count=${#list[@]}
	passed_count=0
	failed_count=0
	skipped_count=0
	echo "Total test cases to run: "$total_count
	echo ""

	# execute all tests run
	tprint_horizontal_line "="
	echo "BEGIN TESTING"
	tprint_horizontal_line "="
	for test_script in "${list[@]}"; do
		bash $test_script
		ret=$?
		if [ $ret == $TEST_SKIP ]; then
			((skipped_count++))
		elif [ $ret == $TEST_PASS ]; then
			((passed_count++))
		else
			((failed_count++))
		fi
		echo ""
		rm -rf $TEST_TEMP_DIRECTORY/*
	done
	unset ret

	# report test results
	tprint_horizontal_line "="
	echo "TEST RESULTS"
	echo "------------"
	echo "Total: $total_count"
	echo "Passed: $passed_count"
	echo "Failed: $failed_count"
	echo "Skipped: $skipped_count"
	tprint_horizontal_line "="

	# end test mode
	unset BASHELL_TEST_ENVIRONMENT
	return 0
}

process_parameters() {
while [[ $# != 0 ]]; do
	case "$1" in
		-h|--help)
			run_help $@
			exit 0
			;;
		-c|--create)
			case "$2" in
				"framework")
					shift 2
					run_create_framework $@
					exit 0
					;;
				"script")
					shift 2
					run_create_test_script $@
					exit 0
					;;
				*)
					print_error_messages --unknownValue
					exit $ERROR_ARGUMENT
					;;
			esac
			;;
		-d|--delete)
			case "$2" in
				"framework")
					shift 2
					run_delete_framework $@
					exit 0
					;;
				"script")
					shift 2
					run_delete_test_script $@
					ret=$?
					exit $ret
					;;
				*)
					print_error_messages --unknownValue
					exit $ERROR_ARGUMENT
					;;
			esac
			;;
		-r|--run)
			shift 1
			run_tests $@
			ret=$?
			exit $ret
			;;
		-i|--install)
			shift 1
			run_create_framework $@
			ret=$?
			exit $ret
			;;
		-u|--uninstall)
			shift 1
			run_delete_framework $@
			ret=$?
			exit $ret
			;;
		*)
			print_error_messages --unknownArg
			break
			exit $ERROR_ARGUMENT
			;;
	esac
done
}

main() {
	if [[ "$1" == "" ]]; then
		run_tests $@
		ret=$?
		exit $ret
	else
		process_parameters $@
	fi
}

if [[ $BASHELL_TEST_ENVIRONMENT != true ]]; then
	main $@
fi