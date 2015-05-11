#!/bin/bash

# User variables
backupDestination="/backups"
FILEMANAGER=thunar

#### Arguments ###
if [[ $1 ]]; then 
	dirToBackup=$1
else
	# Absolute path to this script, e.g. /home/user/bin/foo.sh
	scriptPath=$(readlink -f "$0")
	# Absolute path this script is in, thus /home/user/bin
	scriptDir=$(dirname "$scriptPath")
	dirToBackup=$scriptDir
fi
if [[ $2 ]]; then backupDestination=$2; fi

#################

__createDirIfNotExist() {
	CONTDIR=${1##*/}
	if [[ ! -d $1 ]]; then
		if [[ ! $OSX ]]; then local STATFORMAT='--format=%U';
		else local STATFORMAT='-f %Su'; fi
		if [[ $(stat $STATFORMAT $CONTDIR) == "root" && "$UID" != 0 ]]; then
			if [[ ! $(hash sudo) ]]; then
				NEEDSUDO=sudo
				echo "Need root privilege to create folder in $CONTDIR, using \"sudo\"..."
			else
				echo "${errorcolor}Need root privilege to create folder in $CONTDIR${nocolor}"
			fi
		else 
			NEEDSUDO="" 
		fi

		$NEEDSUDO mkdir -p $1
		$NEEDSUDO chown $USER $1
	fi
}

###############

DIRNAME=$(basename $dirToBackup)
destinationArchivePath=${backupDestination}/"$DIRNAME"_$(date +%Y-%m-%d_%H-%M).zip

__createDirIfNotExist $backupDestination

cd $scriptDir/..
zip -r $destinationArchivePath $dirToBackup
$FILEMANAGER $backupDestination
