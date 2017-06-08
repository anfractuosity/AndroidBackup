# AndroidBackup

Android Backup including grabbing contacts

Usage:

```
./backup.sh /home/user/Phone
```

A number of files will be generated, a tar file containing backup of apks and the SD card. Other files containing contact data will exist as something like phones_2017-06-08_20:50.

You can then use parsephone.py to generate a .csv file of your contact data.

Usage:

```
./parsephone.py /home/user/Phone/email\@email.com_Samsung/phones_2017-06-08_20\:50 out.csv
```
