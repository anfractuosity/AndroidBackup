#!/bin/bash

rm /tmp/backup

adb shell "echo 1"
if [ $? -ne 0 ]; then
	echo "No device"
	exit
fi

EMAIL=$(adb shell dumpsys account | grep "\@" | head -n1 | sed "s/.*Account {name=//g;s/, type=com.google}//g" | tr -d '\r')

MODEL=$(adb shell getprop ro.product.model | tr -d '\r')
ADDR=$(adb shell cat /sys/class/net/wlan0/address | tr -d '\r')

NAME="${EMAIL}_${MODEL}"
mkdir $NAME

adb backup -apk -shared -all -f $NAME/$(date +"%Y-%m-%d_%H:%m").ab

adb shell content query --uri content://contacts/phones > $NAME/phones
adb shell content query --uri content://settings/secure > $NAME/secure
adb shell content query --uri content://settings/global > $NAME/global

dd if=$NAME/$(date +"%Y-%m-%d_%H:%m").ab bs=24 skip=1 > /tmp/backup

zlib-flate -uncompress < /tmp/backup > /tmp/output

mv /tmp/output $NAME

tar --force-local -xf $NAME/output -C $NAME


