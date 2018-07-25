#!/bin/bash

clish -c 'set user admin password ${gaia_pass}' -s

clish -c 'set expert-password ${gaia_pass}' -s

#clish -c 'set interface eth1 ipv4-address INTERNAL-GATEWAY-ADDRESS mask-length INTERNAL-GATEWAYMASKLEN' -s

#clish -c 'set interface eth1 state on' -s

#clish -c 'set hostname HOSTNAME' -s

#config_system -s 'install_security_gw=true&install_ppak=true&install_security_managment=false&ipstat_v6=off&ftw_sic_key=SIC_KEY'

#shutdown -r now

exit 0