#!/bin/bash

echo "##########################################################
#                  Generate new ssh key                  #
#                         See                            #
# https://help.github.com/articles/generating-ssh-keys/  #
#                 for more information                   #
##########################################################"

if [ "$(id -u)" = "0" ]; then
	echo "Don't execute as root, try again without \"sudo\""
	exit 1
fi

echo "Input your email: "
read EMAIL
echo "Just press [Enter] when asked to enter a file to save the key"
ssh-keygen -t rsa -C "$EMAIL"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "\nAdd this to your GitHub account (Settings > SSH keys):\n"
cat ~/.ssh/id_rsa.pub
echo "\nIf you've added the key to your account, do you want to test the connection?"
confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-[y/N]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}
if ! confirm "" ; then exit 0; fi
ssh -T git@github.com
