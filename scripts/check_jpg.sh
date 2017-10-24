#!/bin/bash

FILE=$1
TMP_FILE=/tmp/out

RED='\033[0;31m'
NO_COLOR='\033[0m'

check_result_file() {
  RESULT_FILE=$1
  HINT=${2:""}
  if [ ! -f "$RESULT_FILE" ]; then
    echo "Nothing found..."
    return
  fi

  SIZE=`stat -c %s "$RESULT_FILE"`
  if [ ! "`file $RESULT_FILE`" = "$RESULT_FILE: data" ] && [ $SIZE -ge 1 ]; then
    echo ""
    echo -e "${RED}Found something!!!${NO_COLOR}"
    echo "Result size: $SIZE (type: '`file $RESULT_FILE`')"
    echo "--------------"
    head -n 20 $RESULT_FILE
    echo "--------------"
  else
    echo "Probably no result..."
    echo "Result size: $SIZE (type: '`file $RESULT_FILE`')"
  fi
  rm $RESULT_FILE
}

echo
echo "#################################"
echo "########## JPG CHECKER ##########"
echo "#################################"
echo "Checking file $FILE"
echo
echo "file $FILE:"
file $FILE

echo "identify $FILE:"
identify -verbose $FILE

echo
echo "##############################"
echo "########## exiftool ##########"
echo "##############################"

exiftool $FILE

echo
echo "#############################"
echo "########## binwalk ##########"
echo "#############################"

binwalk $FILE

echo
echo "################################"
echo "########## stegdetect ##########"
echo "################################"

stegdetect $FILE

echo
echo "#############################"
echo "########## strings ##########"
echo "#############################"

strings $FILE | head -n 20
echo "..."
strings $FILE | tail -n 20

echo
echo "##############################"
echo "########## steghide ##########"
echo "##############################"

steghide extract -sf $FILE -p ""

echo
echo "##############################"
echo "########## outguess ##########"
echo "##############################"

outguess -r $FILE $TMP_FILE
check_result_file $TMP_FILE

echo
echo "###################################"
echo "########## outguess-0.13 ##########"
echo "###################################"

outguess-0.13 -r $FILE $TMP_FILE
check_result_file $TMP_FILE

echo
echo "###########################"
echo "########## jsteg ##########"
echo "###########################"

jsteg reveal $FILE $TMP_FILE
check_result_file $TMP_FILE

echo
echo "##################################"
echo "########## stegoVeritas ##########"
echo "##################################"

UUID=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
TMP_DIR=/data/stegoVeritas/$UUID
mkdir -p $TMP_DIR
stegoveritas.py $FILE -outDir $TMP_DIR -meta -imageTransform -colorMap -trailing
