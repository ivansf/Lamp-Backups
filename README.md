=== Lamp Backup Utility ===

0.3 
- Weekly Backups.

0.2
- It nows backup the entire www folder by default, it can be changed at begining of the file

0.1
- It backups testing folders, live folders and /etc
- Exports all MySQL databases into one the backups folder.


=== Installation ===

1. Create a folder to store your backups.
2. Open backups.sh using any editor (like vim). 
3. Change the value of OUTPUTDIR to reflect the folder you just created.
4. Modify the value of DIRTOBACKUP to reflect the folder you want to backup
5. Close the file
6. Open my.cnf using any editor.
7. Input your MySQL user and password.
   - For security reasons you can create a specific user with only reading permissions.
8. Close the file
9. Run ./backups.sh

=== Crontab ===

I include a crontab example to set up this backup to run every day at 00:05 and report 
to that email address

	# m h  dom mon dow   command
	MAILTO="youremailaddress@server.com"
	5 0 * * * /root/bash_backup/backups.sh


A weekly setup example will run the script every night at 23:40 hrs.

	MAILTO="youremailaddress@server.com"
	40 23 * * * /home/<username>/backup_ftp_week.sh


=== TODO ===

- Add an option to rsync the folder after doing the backup

=== Credits ===

Ivan Soto
http://ivansotof.com

Karim Jetha


## Dreamhost Tutorial ##

- Create backup user in Dreamhost control panel
- Select db user and add server IP wildcard to required list
- Change the FTP user to Shell in the control panel.
- Upload backup_ftp_week.sh, chmod to 775 and change variables in script
- Create folder called serverbackups under the user's main folder.
- Test (bash backup_ftp_week.sh)
- Set up cron

	MAILTO="youremailaddress@server.com"
	40 23 * * * /home/<username>/backup_ftp_week.sh
