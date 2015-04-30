#!/bin/bash

FILE="$HOME/.config/applicationsToRun.txt"

SCRIPTPATH=$0
SCRIPTNAME=$(basename $SCRIPT)
SCRIPTNAME=${SCRIPTNAME%.*}

installThis()
{
	if [[ ! -f $FILE ]]; then
		echo -e "# Add the commands you want $SCRIPTNAME to run,\n# one by line" > $FILE
		editor $FILE
	fi
	mkdir -p $HOME/bin; ln -v $SCRIPT $HOME/bin/$SCRIPTNAME;
	exit 0
}

# Check the arguments, use default file if none is given
if [[ -n $1 ]]; then
	if [[ $1 == "--install" ]]; then
		installThis
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

	if [[ -z $(ps aux | grep $PROCESS | grep -v grep) ]]; then
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
		launch $line
	fi
done < $FILE
