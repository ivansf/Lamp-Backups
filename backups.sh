#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

# Select a folder where to store the backups
OUTPUTDIR="/var/serverbackups/"

# mysql options
OPTIONS="--all --complete-insert --add-drop-table --extended-insert --quote-names"
CONFIG_FILE="my.cnf"

# name of the main tarball
BACKUPFILE=www-$(date +%Y-%m-%d)

# removing all files from the folder
echo '-- Cleaning up folders'
rm -rf $OUTPUTDIR*


echo '-- Backing up databases'
# check that backup dir exists
if [ ! -d $OUTPUTDIR ]; then
        mkdir $OUTPUTDIR
fi

# get list of databases
DATABASES=`echo "SHOW DATABASES" | mysql --defaults-file="$CONFIG_FILE" mysql`

for DATABASE in $DATABASES; do

  if [ "$DATABASE" != "Database" ]; then
    # backup database
    mysqldump --defaults-file="$CONFIG_FILE" $OPTIONS $DATABASE > $OUTPUTDIR/$DATABASE.sql
  fi

done

echo '-- Backing up live folders'
tar Pcf $OUTPUTDIR/$BACKUPFILE-public.tar /var/www/*/public

echo '-- Backing up staging folders'
tar Pcf $OUTPUTDIR/$BACKUPFILE-testing.tar /var/www/*/testing

echo '-- Backing up /etc/ folder'
tar Pcf $OUTPUTDIR/$BACKUPFILE-etc.tar /etc

exit 0

