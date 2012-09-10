#!/bin/bash

# Check for passed in parameters and set defaults for production environment.
# First argument is Umlaut directory
# First argument is Umlaut directory
if [ -n "$1" ] ; then
  umlaut_directory=$1
else
  umlaut_directory=/apps/umlaut
fi

# Second argument is Umlaut environment
if [ -n "$2" ] ; then
  umlaut_environtment=$2
else
  umlaut_environtment=production
fi

# Third argument is rake command
if [ -n "$3" ] ; then
  rake_cmd=$3
else
  rake_cmd=rake
fi

# Set log file location
log_file=$umlaut_directory/log/cron

. /etc/profile
cd $umlaut_directory
$rake_cmd --trace --verbose umlaut:nightly_maintenance RAILS_ENV=$umlaut_environtment > $log_file 2>&1
if [ $? -ne 0 ]; then
        date >> $log_file
        mail_file=$umlaut_directory/tmp/tmp.letter
        echo "Below are the contents of the log from the failed nightly maintenance:" > $mail_file
        echo "-------------------------------------------------------" >> $mail_file
        cat $log_file >> $mail_file
        /bin/mail -s "Umlaut nightly maintenance failed" web.services@library.nyu.edu < $mail_file
        cp $log_file $log_file."failed_nightly_maintenance".`date +%Y%m%d%H%M`
fi
