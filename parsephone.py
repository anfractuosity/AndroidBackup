#!/usr/bin/python3

import sqlite3
import glob
import csv
import os
import argparse
import hashlib
import subprocess
import re
import csv

parser = argparse.ArgumentParser()
parser.add_argument("phonefile", help="File with phonenumber output from adb")
parser.add_argument("csv", help="Filename for CSV output")                                                                                                                             
parser.parse_args()
args = parser.parse_args()

phonefile = open(args.phonefile, "r")
init = True

with open(args.csv, 'w') as csvfile:

    for line in phonefile:

        m = re.findall(r'([+A-Za-z0-9_]+)=([+A-Za-z0-9_ ]+)',line)

        hsh = {}                                                                     
        for v in m:                                                                  
            hsh[v[0]]=v[1]               

        if init:
            fieldnames = [k  for  k in hsh.keys()]    
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames,quoting=csv.QUOTE_NONNUMERIC)
            writer.writeheader()
            init = False
        
        writer.writerow(hsh)
