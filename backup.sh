#!/bin/bash

# Usage example: ./backup.sh /home/user/Phone

if [ -d "$1" ]; then
	echo "Using $1 for output directory"
	OUTPUTDIR=$1
else
	echo "Invalid directory"
	exit
fi

# Check phone exists

adb shell "echo 1"
if [ $? -ne 0 ]; then
	echo "No device"
	exit
fi

# Get first email address of account

EMAIL=$(adb shell dumpsys account | grep "\@" | head -n1 | sed "s/.*Account {name=//g;s/, type=com.google}//g" | tr -d '\r')
MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
ADDR=$(adb shell cat /sys/class/net/wlan0/address | tr -d '\r')

NAME="${EMAIL}_${MODEL}"
mkdir "$OUTPUTDIR/$NAME"

DATE=$(date +"%Y-%m-%d_%H:%M")

echo "Starting backup to $OUTPUTDIR/$NAME/$DATE.ab"
adb backup -apk -shared -all -f "$OUTPUTDIR/$NAME/$DATE.ab"

adb shell content query --uri content://contacts/phones > "$OUTPUTDIR/$NAME/phones_$DATE"
adb shell content query --uri content://settings/secure > "$OUTPUTDIR/$NAME/secure_$DATE"
adb shell content query --uri content://settings/global > "$OUTPUTDIR/$NAME/global_$DATE"

# Get right part of file and uncompress 
# See https://nelenkov.blogspot.de/2012/06/unpacking-android-backups.html for more info

dd if="$OUTPUTDIR/$NAME/$DATE.ab" bs=24 skip=1 | zlib-flate -uncompress > "$OUTPUTDIR/$NAME/$DATE.tar"

tar --force-local -xf "$OUTPUTDIR/$NAME/$DATE.ab" -C "$OUTPUTDIR/$NAME"


