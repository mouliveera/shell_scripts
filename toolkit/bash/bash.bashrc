# System-wide .bashrc file for interactive bash(1) shells.
# Created by mveera/toolkit
#   https://github.com/mveera/toolkit

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

if [ -z "$PS1" ]; then
  shopt -s expand_aliases
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

################################################################################
# colors
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
BROWN="\[\033[0;33m\]"
LIGHTGRAY="\[\033[0;37m\]"
DARKGRAY="\[\033[1;30m\]"
LIGHTBLUE="\[\033[1;34m\]"
LIGHTGREEN="\[\033[1;32m\]"
LIGHTCYAN="\[\033[1;36m\]"
LIGHTRED="\[\033[1;31m\]"
LIGHTPURPLE="\[\033[1;35m\]"
YELLOW="\[\033[1;33m\]"
WHITE="\[\033[1;37m\]"
NOCOLOR="\[\033[0m\]"

################################################################################
# import all includes

echo "LOADING bash_includes"
for file in ~/.bash_includes/*.sh
do
  if [[ $(basename $file) == *"README.md"* ]];
  then
    echo " - $(basename $file) exists, but will not be sourced"    
  else
    if [ -f "$file" ]; 
    then
      echo " - Loading \"$file\""
      source "$file"
    else
      echo " - Doesn't exist: \"$file\""
    fi
  fi
done

echo "ADDING ~/.bash_bin to environment"
BASH_BIN=~/.bash_bin
mkdir -p $BASH_BIN
PATH="$BASH_BIN:$PATH"

################################################################################
# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ]; 
then
    case " $(groups) " in *\ admin\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi


