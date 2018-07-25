#!/bin/bash

clish -c 'set user admin password ${gaia_pass}' -s

clish -c 'set expert-password ${gaia_pass}' -s

shutdown -r now

exit 0