#!/bin/bash

# Simple script that creates symlinks from $HOME to all files (except this
# script and the .gitignore) in current working directory. This script must
# thus be run from the directory in which the files we're creating links to
# reside.

SCRIPT=$(basename $0)

if [ ! -e "$PWD/$SCRIPT" ]
then
    echo "Script must be run from the directory in which the files we're creating links to reside."
    exit 1
fi

for FILE in `ls -A`
do
    if [ $FILE != $SCRIPT ] && [ $FILE != '.gitignore' ] && [ $FILE != '.git' ]
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
