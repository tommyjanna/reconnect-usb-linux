#!/usr/bin/env bash

# reconnect-usb.sh
# Simple utility for that resets a USB device connected
# to the system. I use this program when my external
# speakers are unable to play audio.
#
# Tommy Janna, 2021

# Get list of USB devices
mapfile -t deviceList < <(lsusb)
declare -a busDevNums

for (( i=0; i < ${#deviceList[@]}; i++ ))
do
    echo "${i})" $(echo ${deviceList[i]} | cut -d " " -f7-)
    busDevNums[$i]=/dev/bus/usb/$(echo ${deviceList[i]} | awk -F 'Bus ' '{print $2}' | cut -d ' ' -f 1)/$(echo ${deviceList[i]} | awk -F 'Device ' '{print $2}' | cut -d ' ' -f 1 | sed -r 's/(.*):/\1/') 
done

read -p $'\nEnter the number of the device you would like to reconnect (-1 to exit)\n>: ' deviceSelected

if [[ $deviceSelected =~ ^[0-9]+$ ]]
then
    if (( $deviceSelected < ${#deviceList[@]} ))
    then
        sudo ./ioctl-reset ${busDevNums[$deviceSelected]}

        if [ $? = 0 ]
        then
            echo "Device reset sucessfully!"
        else
            echo "Device reset failed!"
        fi
    else
        echo "$0: selection out of bounds" >&2
    fi
else
    echo "$0: invalid input" >&2
fi
