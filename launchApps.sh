#!/bin/bash

FILE="$HOME/.config/applicationsToRun.txt"

SCRIPTPATH=$0
SCRIPTNAME=$(basename $SCRIPTPATH)

printHelp()
{
	echo "Usage: $SCRIPTNAME [sourceFile]
	sourceFile: optional argument containing the commands to run, if no file is specified, $FILE is sourced

	--install [copy/link] [installdir]"
}

installThis()
{
	SCRIPTNAME=${SCRIPTNAME%.*}

	if [[ ! -f $FILE ]]; then
		echo -e "# Add the commands you want $SCRIPTNAME to run,\n# one by line" > $FILE
		editor $FILE
	fi

	if [[ $1 == "copy" ]]; then
		CMD=cp
		shift 1
	elif [[ $1 == "link" ]]; then
		CMD=ln
		shift 1
	fi

	if [[ -n $1 ]]; then
		INSTALLDIR=$1
	else
		INSTALLDIR=$HOME/bin
	fi

	mkdir -p $INSTALLDIR; $CMD -v $SCRIPT $HOME/bin/$SCRIPTNAME;
}

# Check the arguments, use default file if none is given
if [[ -n $1 ]]; then
	if [[ $1 == "--help" || $1 == "-h" ]]; then
		printHelp
		echo 0
	elif [[ $1 == "--install" ]]; then
		installThis $2 $3
		echo 0
	elif [[ -f $1 ]]; then
		FILE=$1;
	else 
		echo "$1 file not found, leave out argument to use $FILE instead"
		exit 1
	fi
else
	if [[ ! -f $FILE ]]; then
		echo "$FILE file not found, create it or pass as argument a text file containing the commands you want to execute, one by line"
		exit 1
	fi
fi

# Run if not already running
launch()
{
	if [[ "$#" -eq 2 ]]; then
		COMMAND=$1; PROCESS=$2;
	else
		COMMAND=$1; PROCESS=$(echo $COMMAND | awk '{print $1}');
	fi

	if [[ -z $(pgrep -f $PROCESS) ]]; then
		echo "Launching "$PROCESS"..."
		# Redirect output to /dev/null and execute in background
		$COMMAND &>/dev/null & 
		# Detach process from terminal 
		#  ($! == PID of last program started in background)
		disown $!
	fi
}

# Read the file and execute the launch function on each line
while read line; do
	if [[ ${line:0:1} != '#' ]]; then
		launch "$line"
	fi
done < $FILE
