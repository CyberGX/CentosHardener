#!/bin/bash

echo -e " \n\n"
echo "  ____      _                ____       "
echo " / ___|   _| |__   ___ _ __ / ___|_  __ "
echo "| |  | | | | '_ \ / _ \ '__| |  _\ \/ / "
echo "| |__| |_| | |_) |  __/ |  | |_| |>  <  "
echo " \____\__, |_.__/ \___|_|   \____/_/\_\\"
echo "      |___/                             "
echo "       Directadmin Hardener - v1.0      "
echo "       https://github.com/CyberGx/      "

# Functions
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
        sed -n "s/^$1\s*=\s*\(\S*\).*$/\1/p" $2
    }

    # $1:Variable, $2:Recomanded String, $3:Advisor
    recommander(){
        if [[ $1 == $2 ]]
        then
            echo $1
        else
            echo "$1 ( Not recomanded )"
            [ ! -z "$3" ] && echo "- " $3
        fi
    }

    recommanderYesOrNo(){
        if [ $1 == $2 ]
        then
            echo "Yes"
        else
            echo "No ( Not recomanded )"
            [ ! -z "$3" ] && echo "- " $3
        fi
    }

    recommanderLower(){
        NUMBER=$(echo "$1" | sed 's/[^0-9]*//g')
        if [ "$NUMBER" -le "$2" ]
        then
            echo "Yes"
        else
            echo "No ( Not recomanded )"
            [ ! -z "$3" ] && echo "- " $3
        fi
    }

# Show Status
echo -e " \n\n ----- Server Status ----- \n"
    
    echo "  # OS : " $(cat /etc/redhat-release)

echo -e " \n\n ----- Services Status -----"
    # Directadmin Status
    echo -e "\n# Directadmin"

    directadmin_options_path=/usr/local/directadmin/custombuild/options.conf
    directadmin_system_email=$(get_config_variable "email" $directadmin_options_path)
    directadmin_autoupdate=$(get_config_variable "da_autoupdate" $directadmin_options_path)
    directadmin_clean_old_webapps=$(get_config_variable "clean_old_webapps" $directadmin_options_path)
    directadmin_webapps_updates=$(get_config_variable "webapps_updates" $directadmin_options_path)
    directadmin_updates=$(get_config_variable "updates" $directadmin_options_path)

    echo "  * Directadmin Options path :" $directadmin_options_path
    echo "  - Directadmin system email :" $directadmin_system_email
    echo "  - Directadmin automatic update :" $(recommander $directadmin_autoupdate "yes")
    echo "  - Clean old webapps :" $(recommander $directadmin_clean_old_webapps "yes")
    echo "  - Webapps updates :" $(recommander $directadmin_webapps_updates "yes")
    echo "  - Updates :" $(recommander $directadmin_updates "no" "it better to update manualy")

    directadmin_config_path=/usr/local/directadmin/conf/directadmin.conf
    echo -e "\n  * Directadmin Config path :" $directadmin_config_path


    # Mysql Status
    echo -e "\n# MYSQL"
    mysql_config_path=/etc/my.cnf
    mysql_bind_address=$(get_config_variable "bind-address" $mysql_config_path)

    echo "  * Mysql config path :" $mysql_config_path
    echo "  - Is mysql listen only on localhost :" $(recommanderYesOrNo $mysql_bind_address "127.0.0.1" "it better to disable remote access")

    # PHP Status
    echo -e "\n# PHP"
    php_ini_path=$(/usr/local/bin/php --ini | sed -n "s/^Loaded Configuration File\s*:\s*\(\S*\).*$/\1/p")
    php_disable_functions=$(get_config_variable "disable_functions" $php_ini_path)
    php_expose=$(get_config_variable "expose_php" $php_ini_path)
    php_display_errors=$(get_config_variable "display_errors" $php_ini_path)
    php_log_errors=$(get_config_variable "log_errors" $php_ini_path)
    php_allow_url_include=$(get_config_variable "allow_url_include" $php_ini_path)
    php_allow_url_fopen=$(get_config_variable "allow_url_fopen" $php_ini_path)
    php_post_max_size=$(get_config_variable "post_max_size" $php_ini_path)
    echo "  * PHP.ini path :" $php_ini_path
    echo "  - PHP Version :" $(php -v | sed 's/(.*//' | head -1)
    echo "  - is Expose PHP OFF :" $(recommanderYesOrNo $php_expose "Off" "To restrict PHP information leakage set expose_php=Off")
    echo "  - is Display Errors OFF :" $(recommanderYesOrNo $php_display_errors "Off" "Set display_errors=Off, Do not expose PHP error messages to all site visitors.")
    echo "  - is Logging Enable :" $(recommanderYesOrNo $php_log_errors "On" "To enable logging system set log_errors=Off")
    echo "  - is allow_url_include Disable :" $(recommanderYesOrNo $php_allow_url_include "Off" "To prevent Remote Code Execution set allow_url_include=Off")
    echo "  - is allow_url_fopen Disable :" $(recommanderYesOrNo $php_allow_url_fopen "Off" "To prevent Remote Code Execution set allow_url_fopen=Off")
    echo "  - is php_post_max_size lower than 64M :" $(recommanderLower $php_post_max_size "64" "To prevent attacker to send oversized POST requests to eat your system resources, set php_post_max_size<64M")
    echo "  - Disable Functions :" $php_disable_functions