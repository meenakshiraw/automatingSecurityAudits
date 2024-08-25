#!/bin/bash

#Verify that a firewall (e.g., iptables, ufw) is active and configured to block unauthorized access.



# Function to check if firewalld is active and running
check_firewalld() {
    if systemctl is-active --quiet firewalld
    then
        echo "Firewalld is active and running."
        echo "Firewalld configuration:"
        firewall-cmd --list-all
    else
        echo "Firewalld is not active."
    fi
}

# Function to check if iptables is active and running
check_iptables() {
   
    if systemctl is-active --quiet iptables
    then
        echo "iptables is active and running."
        echo "iptables rules:"
        iptables -L
    else
        echo "iptables is not active."
    fi
}

# Function to check if ufw is active and running


check_nftables() {
    if systemctl is-active --quiet ufw; then
        echo "ufw is active and running."
        echo "ufw rules:"
        ufw app list
    else
        echo "ufw is not active."
    fi
}


# Function to set up firewalld to block unauthorized access

configure_firewalld() {
    # Start and enable firewalld
    echo "Starting and enabling firewalld..."
    systemctl start firewalld
    systemctl enable firewalld

    # Set default zone to block
    echo "Setting default zone to 'drop' (block all incoming connections)..."
    firewall-cmd --set-default-zone=drop
    echo "--------------------------"
    echo "--------------------------"

    # Allow SSH
    echo "Allowing SSH connections..."
    firewall-cmd --permanent --zone=public --add-service=ssh

    echo "--------------------------"
    echo "--------------------------"


    # echo "Allowing HTTP and HTTPS connections..."
    firewall-cmd --permanent --zone=public --add-service=http
     firewall-cmd --permanent --zone=public --add-service=https



    # Reload firewalld to apply changes
    echo "Reloading firewalld to apply changes..."
    firewall-cmd --reload
    echo "--------------------------"
    echo "--------------------------"

    # Display the active rules

}

# Main function to verify firewall status and configuration

check_firewall() {
    echo "Checking firewall status and configuration..."

    # Check for firewalld
    if systemctl list-units --type=service | grep -q firewalld
    then
        check_firewalld
    else
        echo "Firewalld is not installed."
    fi
    echo "--------------------------"
    echo "--------------------------"

    # Check for iptables
    if systemctl list-units --type=service | grep -q iptables
    then
        check_iptables
    else
        echo "iptables is not installed."
    fi

    # Check for ufw
    if systemctl list-units --type=service | grep -q ufw
    then
        check_nftables
    else
        echo "ufw is not installed."
    fi


    echo "configuration firewall to block unauthorized access"

    configure_firewalld
}

# Run the firewall check
check_firewall


