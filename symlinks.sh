#!/bin/bash

# Simple script that creates symlinks from $HOME to all files (except this
# script and the .gitignore) in current working directory. This script must
# thus be run from the directory in which the files we're creating links to
# reside.

if [ $# -eq 1 ] && [ $1 = 'remove' ]; then
    REMOVE=1
else
    REMOVE=0
fi

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
        if [ $REMOVE -eq 1 ]
        then
            if [ -L $TARGET ]
            then
                rm $TARGET
            elif [ -e $TARGET ]
            then
                echo "$TARGET is not a symbolic link!"
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
