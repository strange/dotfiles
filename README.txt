Run the ``symlinks.sh`` script to create symlinks to the "dot-files" from this
repository.

Create a .muttrc with the following contents::

    set imap_user="<username>@<domain>"
    set imap_pass="<password>"

    set smtp_url="smtp://<username>@<domain>@smtp.gmail.com:587/"
    set smtp_pass="<password>"

    source ~/.mutt/muttrc
