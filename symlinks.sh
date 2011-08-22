#!/bin/bash

# A simple script that automatically generates symlinks for the various
# configurations available in this package. The script must be run from
# the directory in which the files we're creating symlinks for reside.

function createsymlinks() {
    local script=$(basename $0)

    if [ ! -e "$PWD/$script" ]
    then
        echo "Script must be run from the directory in which the files we're " \
             "creating links to reside."
        exit 1
    fi

    # first checkout submodules

    git submodule update --init

    local exclude=".gitignore .git README.txt .bashrc.local.skel $SCRIPT"

    for filename in `ls -A`
    do
        if [[ "${exclude}" != *${filename}* ]]; then
            local from="$PWD/$filename"
            local to="$HOME/$filename"

            if [ $# -eq 1 ] && [ $1 = 'remove' ]; then
                if [ -L $to ]; then
                    rm $to
                fi
            else
                if [ -e $to ]; then
                    if  [[ $(readlink $to) != $from ]]; then
                        echo "A file named $to already exists!"
                    fi
                else
                    ln -s $from $to
                fi
            fi
        fi
    done
}
createsymlinks
