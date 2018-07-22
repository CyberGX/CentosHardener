#!/bin/bash

# Secure PHP & Add Disabled Function
# cd /usr/local/directadmin/custombuild; ./build update; ./build secure_php

echo "Email : "
read email


sed 's/email@domain.com/$email/g' report.txt

# Regular updates of system services, libraries and scripts.
#cd /usr/local/directadmin/custombuild; ./build update; ./build all d