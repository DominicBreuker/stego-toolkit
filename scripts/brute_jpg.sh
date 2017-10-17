#!/bin/bash

FILE=$1
WORDLIST=$2

echo "Checking file $FILE with wordlist $WORDLIST"

echo
echo "##############################"
echo "########## steghide ##########"
echo "##############################"

pybrute.py -f $FILE -w $WORDLIST steghide

echo
echo "##############################"
echo "########## outguess ##########"
echo "##############################"

pybrute.py -f $FILE -w $WORDLIST outguess

echo
echo "###################################"
echo "########## outguess-0.13 ##########"
echo "###################################"

pybrute.py -f $FILE -w $WORDLIST outguess-0.13

echo
echo "###############################"
echo "########## stegbreak ##########"
echo "###############################"

echo " -stegbreak (format=outguess)"
stegbreak -t o -f $WORDLIST $FILE

echo " -stegbreak (format=jphide)"
stegbreak -t p -f $WORDLIST $FILE

echo " -stegbreak (format=jsteg)"
stegbreak -t j -f $WORDLIST $FILE

echo
echo "##################################"
echo "########## stegoVeritas ##########"
echo "##################################"

# UUID=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
# TMP_DIR=/data/stegoVeritas/$UUID
# mkdir -p $TMP_DIR
#
# echo "Running stegoVerits takes time. Be patient and check out '$TMP_DIR' afterwards..."
# stegoveritas.py $FILE -outDir $TMP_DIR -bruteLSB
