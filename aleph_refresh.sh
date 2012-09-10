#!/bin/bash

# Check for passed in parameters and set defaults for production environment.
# First argument is Umlaut directory
if [ -n "$1" ] ; then
  umlaut_directory=$1
else
  umlaut_directory=/apps/umlaut
fi

# Second argument is Aleph table mount
if [ -n "$2" ] ; then
  aleph_table_mnt=$2
else
  aleph_table_mnt='/mnt/aleph_tab/'
fi

# Third argument is rake command
if [ -n "$3" ] ; then
  rake_cmd=$3
else
  rake_cmd=rake
fi

# Fourth argument is mail command
if [ -n "$4" ] ; then
  mail_cmd=$4
else
  mail_cmd=/bin/mail
fi

# Set environment
umlaut_environment=production

# Set log file location
log_file=$umlaut_directory/log/cron

. /etc/profile
cd $umlaut_directory
$rake_cmd --trace --verbose exlibris:aleph:refresh RAILS_ENV=$umlaut_environment > $log_file 2>&1
if [ $? -ne 0 ]; then
        date >> $log_file
        mail_file=$umlaut_directory/tmp/tmp.letter
        echo "Below are the contents of the log from the failed Aleph refresh:" >> $mail_file
        echo "-------------------------------------------------------" >> $mail_file
        cat $log_file >> $mail_file
        $mail_cmd -s "Umlaut Aleph refresh failed" web.services@library.nyu.edu < $mail_file
        cp $log_file $log_file."failed_aleph_refresh".`date +%Y%m%d%H%M`
fi
