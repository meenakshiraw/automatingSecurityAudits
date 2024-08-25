#!/bin/bash


# Scan for files and directories with world-writable permissions. 


echo "Scanning for writable directories: "
find / -type d -perm -o+w 2>/dev/null 

echo " scanning for writable files : "

find / -type f -perm -o+w  2>/dev/null



# Check for the presence of .ssh directories and ensure they have secure permissions


echo "Check for the presence of .ssh directories and ensure they have secure permissions"



# looping through all users which are in home directories 


for all_users in /home/* /root
do
	ssh_dir="$all_users/.ssh"


        if [[ -d "$ssh_dir" ]]
	then 
		echo " .ssh has been found in $all_users"
	

		# checking whether they have secured  ..sh has secured permission

		if [ "$(stat -c %a "$ssh_dir")" -ne 700 ]
		then
			echo " set the permission of $ssh_dir to 700"
			chmod 700 "$ssh_dir"
		else 
			echo "Permission of $ssh_dir are already secured "
		fi

	         # checing the files in .ssh directory for permission 

		for file in "$ssh_dir"/*
		do 
			if [ -f "$file" ]
			then

			# checking whetehr file has a permissions if it doesnt have permission then seting its permisison
		        
		           if [ "$(stat -c %a "$file")" -ne 600 ]
			   then
			       echo "Setting file permission of $file to 600"
		           chmod 600 "$file"
		        
		           else 
		               echo " Persmission of $file has been already secured "
	                   fi
		        fi
		done
	fi
done 	







# Report any files with SUID or SGID bits set, particularly on executables.


echo " Files  which has SUID bit set : "

find / -type f -perm /4000 -exec ls -1 {} \; 2>/dev/null

echo "Files with SGID bit set : "

find / -type f -perm /2000 -exec ls -l {} \; 2>/dev/null


