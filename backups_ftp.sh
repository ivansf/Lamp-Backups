#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin

#=========================================
# ACCOUNT INFORMATION
#=========================================

OUTPUTDIR=""             # Where to store backups
DIRTOBACKUP=""             # What to backup
OUTPUTFILE=""
FTPHOST=""
FTPUSER=""
FTPPASS=""
DBUSER=""
DBPASS=""
DBHOST=""

#=========================================
# DON'T CHANGE ANYTHING AFTER THIS.
#=========================================

# mysql options
OPTIONS="--all --complete-insert --add-drop-table --extended-insert --quote-names"

# name of the main tarball
# BACKUPFILE=www-$(date +%Y-%m-%d)

# removing all files from the folder
echo '-- Cleaning up folders'
rm -rf $OUTPUTDIR*

echo '-- Backing up databases'
# check that backup dir exists
if [ ! -d $OUTPUTDIR ]; then
    mkdir $OUTPUTDIR
fi

# get list of databases

DATABASES=`echo "SHOW DATABASES" | mysql -h $DBHOST -u $DBUSER -p$DBPASS`

for DATABASE in $DATABASES; do
  if [ "$DATABASE" != "Database" ]; then
    # backup database
    mysqldump -h $DBHOST -u $DBUSER -p$DBPASS $OPTIONS $DATABASE > $OUTPUTDIR/$DATABASE.sql
  fi
done

echo '-- Backing up live folders'
tar Pcf $OUTPUTDIR/$OUTPUTFILE $DIRTOBACKUP

#=========================================
# UPLOAD FILE USING FTP
#=========================================

cd $OUTPUTDIR
ftp -inv $FTPHOST << EOF
user $FTPUSER $FTPPASS
mput *

bye
EOF

exit 0

