#!/bin/bash

echo -e " \n\n"
echo "  ____      _                ____"
echo " / ___|   _| |__   ___ _ __ / ___|_  __"
echo "| |  | | | | '_ \ / _ \ '__| |  _\ \/ /"
echo "| |__| |_| | |_) |  __/ |  | |_| |>  < "
echo " \____\__, |_.__/ \___|_|   \____/_/\_\\"
echo "      |___/"
echo "       Directadmin Hardener - v1.0      "
echo "        http://github.com/CyberGx       "

config_editor(){
    sed -i 's/\(^'"$1"'=\).*/\1'"$2"'/' $3
}

set_directadmin_option(){
    config_editor $1 $2 $directadmin_options_path
}

is_string_exist (){
    grep -Fxq $1 $2
}

# $1:String, $2:Filepath
get_config_variable (){
    sed -n "s/^.*$1\s=\s*\(\S*\).*$/\1/p" $2
}

directadmin_options_path=/usr/local/directadmin/custombuild/options.conf

# Useful Variables
mysql_bind_address=$(get_config_variable "bind-address" /etc/my.cnf)

# Show Status
echo -e " \n\n ----- Status ----- \n"
echo "# MYSQL"

echo -n "- Is mysql listen only on localhost : "
if [ $mysql_bind_address == "127.0.0.1" ]
then
    echo "Yes"
    mysql_bind_to_local="true"
else
    # need to bind to localhost
    echo "No ( Not recomanded )"
    mysql_bind_to_local="false"
fi
