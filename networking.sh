#!/bin/bash
# Network connection manager v2

# list of interfaces
INTERFACES=($(ls -I lo /sys/class/net))
# interface to be used
INTERFACE=

# Stop the current active profile of netctl connected to the interface
networking_stop_netctl_profile() {
    PROFILES=($(netctl list | grep '*' | awk '{ print $2 }'))
    for PROFILE in "${PROFILES[@]}"
    do
        if [[ $(grep "Interface=$INTERFACE" /etc/netctl/$PROFILE) == "Interface=$INTERFACE" ]]; then
            sudo netctl stop $PROFILE
            break
        fi
    done
}

# Disable networking on an interface
networking_stop() {
    echo "[*] Stopping connections / networking on $INTERFACE"
    sudo ip link set $INTERFACE down
    sudo dhcpcd -k $INTERFACE > /dev/null 2>&1
    sudo systemctl stop wpa_supplicant.service
    networking_stop_netctl_profile
    echo "[+] Disconnected on $INTERFACE"
}

# Disable networking on all interfaces
networking_stopall() {
    for i in "${!INTERFACES[@]}"
    do
        INTERFACE=${INTERFACES[$i]}
        networking_stop
    done
}

# Enable networking  by starting required services
networking_start() {
    echo "[*] Starting required utilities"
    sudo systemctl start wpa_supplicant.service
    echo "[+] Utilities started"
}

# Connect to a network on a specified interface
networking_connect() {
    networking_stop
    networking_start

    # temporary ethernet workaround
    if [[ $INTERFACE == "eth0" ]]; then
    #    sudo ip link set eth0 up
    #    sudo dhcpcd eth0
    #    echo "[+] Connected with $INTERFACE"
        echo "[*] Ethernet device detected."
        read -r -p "[?] Use predefined DHCP eth0 profile? [Y/n] " RESPONSE
        case "$RESPONSE" in
            [nN][oO]|[nN])
                echo "[*] Please set up a manual ethernet connection."
                echo "[*] See https://wiki.archlinux.org/index.php/Netctl for help"
                echo "[*] and /etc/netctl/examples/ for examples on how to setup a"
                echo "[*] custom ethernet connection."
                ;;
            *)
                sudo netctl start ethernet
                if [[ $(ifconfig | grep "$INTERFACE") == "" ]]; then
                    echo "[!] Ethernet connection failed"
                else
                    echo "[+] Ethernet connection established"
                fi
                ;;
        esac
        echo "[+] Done." 
        exit 1
    fi

    sudo wifi-menu -o $INTERFACE
    ESSID=$(iwconfig $INTERFACE | grep ESSID | awk '{ print $4 }' | sed 's/ESSID://')
    if [[ "$ESSID" == "off/any" ]]; then
        echo "[!] Connection with $INTERFACE failed"
    else
        echo "[+] Connected with $INTERFACE to $ESSID"
    fi
    echo "[+] Done."
}

# Select an interface to connect with
networking_select_interface() {
    echo "[+] Select the interface you want to connect with: "
    for i in "${!INTERFACES[@]}"
    do
        echo "$i: ${INTERFACES[$i]}"
    done

    read -n1 -s i

    if [[ ! ${INTERFACES[i]+test} ]]; then
        echo "[!] Unknown interface used. Exiting..."
        exit 2
    fi
    INTERFACE=${INTERFACES[i]}
}


# Main entry point
if [  $# -eq 1 ]; then
    if [[ "$1" == "stopall" ]]; then
        networking_stopall
        exit
    fi
    networking_select_interface
elif [ $# -eq 2 ]; then
    for i in "${INTERFACES[@]}"
    do
        if [ "$i" == "$2" ]; then
            INTERFACE=$2
            break
        else
            INTERFACE=false
        fi
    done
    if [[ "$INTERFACE" == "false" ]]; then
        echo "[!] Unknown interface used. Exiting..."
        exit 2
    fi
else
    echo "$0 {stop | stopall | connect | start} [interface]"
    exit 2
fi

echo "[*] Interface set, using $INTERFACE"
case $1 in
    "stop") networking_stop ;;
    "stopall") networking_stopall ;;
    "connect"|"start") networking_connect ;;
    *) echo "$1 is not a valid argument" ;;
esac
