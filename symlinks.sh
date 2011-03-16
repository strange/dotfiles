#!/bin/bash

# A simple script that automatically generates symlinks for the various
# configurations available in this package. The script must be run from
# the directory in which the files we're creating symlinks for reside.

SCRIPT=$(basename $0)

if [ ! -e "$PWD/$SCRIPT" ]
then
    echo "Script must be run from the directory in which the files we're " \
         "creating links to reside."
    exit 1
fi

# first checkout submodules

git submodule update --init

EXCLUDE=".gitignore .git README.txt .bashrc.local.skel $SCRIPT"

for FILE in `ls -A`
do
    if [[ "${EXCLUDE}" != *${FILE}* ]]
    then
        SOURCE="$PWD/$FILE"
        TARGET="$HOME/$FILE"
        if [ $# -eq 1 ] && [ $1 = 'remove' ]
        then
            if [ -L $TARGET ]
            then
                rm $TARGET
            fi
        else
            if [ -e $TARGET ]
            then
                echo "A file named $TARGET already exists!"
            else
                ln -s $SOURCE $TARGET
            fi
        fi
    fi
done
