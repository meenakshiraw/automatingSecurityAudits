#!/bin/bash

#Identify whether the server's IP addresses are public or private. 
# Provide a summary of all IP addresses assigned to the server, specifying which are public and which are private. 


check_ip(){

private_ip=(
"10.0.0.0/8"
"172.16.0.0/12"
"192.168.0.0/16"
)

#install ipcalc by entering sudo yum install ipcalc -y 

for range in ${private_ip[*]}
do
	if  [[ $ip == $(ipcalc -n $range | awk -F= '{print $2}' | cut -d'/' -f1)* ]]
        then
		echo "$ip is a private ip"
		exit 1
	fi
done
echo "$ip is a public ip "
}
ip_add=$(hostname -I)


for ip in $ip_add
do
	
#Ensure that sensitive services (e.g., SSH) are not exposed on public IPs unless required.
	if check_ip $ip
        then
                ssh_service=$(ss -tnlp | grep ":22" | grep -w "$ip")
                if [[  $ssh_service ]]
                then
			echo "-------------------"
                        echo "-------------------"

                        echo "SSH is exposed on public ip :$ip"
                fi
        fi

done

echo "-------------------"
echo "-------------------"
echo "SSH is not exposed on public ip "
