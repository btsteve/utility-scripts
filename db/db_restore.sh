#!/bin/bash
# Usage instructions
function Usage {
  printf "\n"
  printf "Usage: \n"
  printf "  restore_dbs.sh [options]\n\n"

  printf "Note:\n"
  printf "  These variables can be set via the command-line arguments shown below \n"
  printf "  or via environment variables named as shown as the parameter for the \n"
  printf "  arguments. \n\n"
  printf " filenames and db names are expected to be the same and in the directory with the script \n"  
  printf "General Options: \n"
  printf "  -u <mysql_username>           The Mysql username \n"
  printf "  -p <mysql_password>        mysql passowrd \n"
  printf "  -h <mysql_restore_hostname>  hostname to restore too. \n"
  printf "  -d <array_of_dbs> (%s) array of dbs to restore\n" 
  printf "\n"
}
while getopts u:p:h: flag
do
    case "${flag}" in
        u) user=${OPTARG};;
        p) password=${OPTARG};;
        h) host=${OPTARG};;
        d) databases+=${OPTARG};;
        *) Usage;
            exit;
    esac
done
for val in ${databases[@]}; do
    now=$(date +"%T")
    echo "Current time : $now"
    echo "starting restore: $val"
    mysql -h $host -u $user -p$password --ssl-mode disable --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;" --force  $val < $val.sql
    finish=$(date +"%T")
    echo "Finish time: $finish"
done
