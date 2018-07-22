#!/bin/bash

# Secure PHP & Add Disabled Function
# cd /usr/local/directadmin/custombuild; ./build update; ./build secure_php


read -p 'Email : ' email
sed 's/email@domain.com/$email/g' /usr/local/directadmin/custombuild/options.conf

# Regular updates of system services, libraries and scripts.
#cd /usr/local/directadmin/custombuild; ./build update; ./build all d