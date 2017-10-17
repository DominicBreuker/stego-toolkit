#!/bin/bash

FILE=$1
WORDLIST=$2

echo "Checking file $FILE with wordlist $WORDLIST"

echo
echo "###############################"
echo "########## openstego ##########"
echo "###############################"

pybrute.py -f $FILE -w $WORDLIST openstego

echo
echo "##################################"
echo "########## stegoVeritas ##########"
echo "##################################"

UUID=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
TMP_DIR=/data/stegoVeritas/$UUID
mkdir -p $TMP_DIR

echo "Running stegoVerits takes time. Be patient and check out '$TMP_DIR' afterwards..."
stegoveritas.py $FILE -outDir $TMP_DIR -meta -bruteLSB -imageTransform -colorMap -trailing
