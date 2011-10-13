Run the ``symlinks.sh`` script to create symlinks to the "dot-files" from this
repository.

Create a .muttrc with the following contents::

    set imap_user="<username>@<domain>"
    set imap_pass="<password>"

    set smtp_url="smtp://<username>@<domain>@smtp.gmail.com:587/"
    set smtp_pass="<password>"

    source ~/.mutt/muttrc

Adding submodules to pathogen:

    git submodule add <path> .vim/bundle/<name>
    git submodule init && git submodule update

Update all submodules:

    git submodule foreach git checkout master && git submodule foreach git pull origin master
