#!/bin/bash

# Names
export alces_HOSTNAME="${alces_PERSONALITY}1"
export alces_APPLIANCE_NAME="$(echo ${alces_PERSONALITY^})"

# Internal IP configuration information
export alces_INTERNAL_INTERFACE="eth0"
export alces_INTERNAL_IP="1" # set this to 'dhcp' to configure the interface to use dhcp
export alces_INTERNAL_NETMASK="255.255.0.0"
export alces_INTERNAL_GATEWAY=""

# External IP configuration information
export alces_EXTERNAL_INTERFACE="eth1"
export alces_EXTERNAL_IP="" # set this to 'dhcp' to configure the interface to use dhcp
export alces_EXTERNAL_NETMASK="255.255.0.0"
export alces_EXTERNAL_GATEWAY=""

# Users
## Replace this with the password to be used by the `root` CLI user
export alces_ROOT_PASS=""
## Replace this with the password to be used by the `alces` CLI user
export alces_ALCES_PASS=""
## Replace this with the password to be used by the `siteadmin` CLI user and the `siteadmin` Overware user
export alces_SITEADMIN_PASS=""
## Replace these with the Flight Center VPN user details for the cluster
export alces_VPN_USER=""
export alces_VPN_PASS=""
