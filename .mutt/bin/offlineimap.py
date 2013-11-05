#!/usr/bin/python
import re, subprocess
def get_keychain_pass(user, account, server):
    params = {
        'security': '/usr/bin/security',
        'command': 'find-internet-password',
        'account': account,
        'server': server,
        'user': user,
        'keychain': '/Users/%s/Library/Keychains/login.keychain' % user,
    }
    command = ("sudo -u %(user)s %(security)s -v %(command)s -g "
               "-a %(account)s -s %(server)s %(keychain)s" % params)
    output = subprocess.check_output(command, shell=True,
                                     stderr=subprocess.STDOUT)
    outtext = [l for l in output.splitlines()
               if l.startswith('password: ')][0]

    return re.match(r'password: "(.*)"', outtext).group(1)
