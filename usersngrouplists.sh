#!/bin/bash

#listing all users and groups on the server

echo " See the all users and group lists in userngrouplist.txt "
all_users=$(cat /etc/passwd | cut -d: -f1)

all_group=$(cat /etc/group | cut -d: -f1)

echo " all users names are " >usersngrouplist.txt

echo "----------------------------">>usersngrouplist.txt

echo "------------------------------">>usersngrouplist.txt


echo -e " $all_users" >> usersngrouplist.txt
echo "------------------------------">>usersngrouplist.txt

echo "------------------------------">>usersngrouplist.txt


echo -e  " all group list names are " >>usersngrouplist.txt
echo "$all_group" >> usersngrouplist.txt


# checking if the user is root or not 

echo "	Check for users with UID 0 (root privileges) and report any non standard users"

uid_users=$(cat /etc/passwd | awk -F: '$3 == 0 {print $1}')


for user in $uid_users
do
	if [[ $user != 0 ]]
        then
		echo " this is standard user because UID is not 0 "
	else
		echo "this is root user "
	fi
done



#Identify and report any users without passwords or with weak passwords



### Reporting Users with Empty or Weak Passwords:

echo "---------------------"
echo "---------------------"

# Report users without passwords
echo "Checking for users without passwords:"
without_passwd=$(awk -F: '($2 == "" || $2 == "x") {print $1}' /etc/shadow)

if [ -z "$without_passwd" ]
then
    echo "No users found without passwords."
else
    echo "Users without passwords:"
    echo "$without_passwd"
fi

echo "---------------------"
echo "---------------------"

#we uses john tool which is password-cracking tool so install it first before running this script
#Checking  for weak passwords (using john)


echo "Checking for weak passwords..."
sudo unshadow /etc/passwd /etc/shadow > /tmp/passwd.hashes
sudo john /tmp/passwd.hashes > /tmp/john_results

if grep -q "No password hashes left to crack" /tmp/john_results
then
    echo "No weak passwords found."
else
    echo "Weak passwords found:"
    grep -v "No password hashes left to crack" /tmp/john_results
fi

# Clean up
rm /tmp/passwd.hashes /tmp/john_results




