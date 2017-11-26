#!/bin/bash

FILE=$1
TMP_FILE=/tmp/out

RED='\033[0;31m'
NO_COLOR='\033[0m'

check_result_file() {
  RESULT_FILE=$1
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
    echo ""
    echo "Probably no result..."
    echo "Result size: $SIZE (type: '`file $RESULT_FILE`')"
  fi
  rm $RESULT_FILE
}

echo
echo "#################################"
echo "########## PNG CHECKER ##########"
echo "#################################"
echo "Checking file $FILE"
echo
file $FILE

echo "identify $FILE:"
identify  -verbose $FILE

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
echo "###########################"
echo "########## zsteg ##########"
echo "###########################"
echo
echo "Watch out for red output. This tool shows lots of false positives..."

zsteg $FILE -a

echo
echo "###############################"
echo "########## openstego ##########"
echo "###############################"

openstego extract -sf $FILE -p "''" -xf $TMP_FILE
check_result_file $TMP_FILE

echo
echo "#################################"
echo "########## stegano-lsb ##########"
echo "#################################"

for ENCODING in UTF-8 UTF-32LE; do
  echo "- stegano-lsb (encoding $ENCODING)"
  stegano-lsb reveal --input $FILE -e $ENCODING -o $TMP_FILE
  check_result_file $TMP_FILE
done

echo
echo "#####################################"
echo "########## stegano-lsb-set ##########"
echo "#####################################"

# TODO: check why stegano is so buggy...
# - geneators not working: ackermann ackermann_naive (require arguments - how to parse?)

for GENERATOR in composite eratosthenes fermat fibonacci identity log_gen mersenne triangular_numbers; do
  # generator 'carmichael' left out since it is slow
  for ENCODING in UTF-8 UTF-32LE; do
    echo "- stegano-lsb-set (generator $GENERATOR | encoding $ENCODING)"
    stegano-lsb-set reveal --input $FILE -e $ENCODING -g $GENERATOR -o $TMP_FILE
    check_result_file $TMP_FILE
  done
done

echo
echo "#################################"
echo "########## stegano-red ##########"
echo "#################################"

stegano-red reveal --input $FILE

echo
echo "##############################"
echo "########## LSBSteg  ##########"
echo "##############################"

# seems to fail most of the time we did not encode something with it
# no file will be created in these cases
LSBSteg decode -i $FILE -o $TMP_FILE 2>/dev/null
check_result_file $TMP_FILE

echo
echo "##################################"
echo "########## stegoVeritas ##########"
echo "##################################"

UUID=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
TMP_DIR=/data/stegoVeritas/$UUID
mkdir -p $TMP_DIR
stegoveritas.py $FILE -outDir $TMP_DIR -meta -imageTransform -colorMap -trailing
