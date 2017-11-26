#!/bin/bash

PASSPHRASE=abcd
COVER_IMAGE_JPG=ORIGINAL.jpg
COVER_IMAGE_PNG=ORIGINAL.png
COVER_AUDIO_WAV=ORIGINAL.wav
COVER_AUDIO_MP3=ORIGINAL.mp3
STEGO_FILES_FOLDER_JPG=stego-files/jpg
STEGO_FILES_FOLDER_PNG=stego-files/png
STEGO_FILES_FOLDER_WAV=stego-files/wav
STEGO_FILES_FOLDER_MP3=stego-files/mp3

if [ ! -e $COVER_IMAGE_JPG ]; then
    echo "Original image file $COVER_IMAGE_JPG does not exist. Exiting..."
    exit 1
fi
if [ ! -e $COVER_IMAGE_PNG ]; then
    echo "Original image file $COVER_IMAGE_PNG does not exist. Exiting..."
    exit 1
fi
if [ ! -e $COVER_AUDIO_WAV ]; then
    echo "Original audio file $COVER_AUDIO_WAV does not exist. Exiting..."
    exit 1
fi
if [ ! -e $COVER_AUDIO_MP3 ]; then
    echo "Original audio file $COVER_AUDIO_MP3 does not exist. Exiting..."
    exit 1
fi
mkdir -p $STEGO_FILES_FOLDER_JPG
mkdir -p $STEGO_FILES_FOLDER_PNG
mkdir -p $STEGO_FILES_FOLDER_WAV
mkdir -p $STEGO_FILES_FOLDER_MP3

echo "Embedding secret message into images using various tools"
echo "Passphrase: '$PASSPHRASE'"

SECRET_MESSAGE=secret_message.txt
SECRET_MESSAGE_B64="`cat $SECRET_MESSAGE | base64`"
echo ""
echo "########### SECRET MESSAGE ###########"
cat $SECRET_MESSAGE
echo "######################################"

###############################
############# JPG #############
###############################

COVER_IMAGE=$COVER_IMAGE_JPG
STEGO_FILES_FOLDER=$STEGO_FILES_FOLDER_JPG

echo ""
echo "Embedding into $COVER_IMAGE now ..."

############# steghide #############

echo ""
echo "... steghide"
steghide embed -f -ef $SECRET_MESSAGE -cf $COVER_IMAGE -p $PASSPHRASE -sf $STEGO_FILES_FOLDER/steghide.jpg

############# outguess #############

echo ""
echo "... outguess"
outguess -k $PASSPHRASE -d $SECRET_MESSAGE $COVER_IMAGE $STEGO_FILES_FOLDER/outguess.jpg

############# outguess-0.13 #############

echo ""
echo "... outguess"
outguess-0.13 -k $PASSPHRASE -d $SECRET_MESSAGE $COVER_IMAGE $STEGO_FILES_FOLDER/outguess-0.13.jpg

############# jphide/jpseek #############

# echo ""
# echo "... jphide (interactive passphrase, use '$PASSPHRASE')"
# jphide $COVER_IMAGE $STEGO_FILES_FOLDER/jphide.jpg $SECRET_MESSAGE

############# jsteg #############

echo ""
echo "... jsteg (has no passphrase)"
jsteg hide $COVER_IMAGE $SECRET_MESSAGE $STEGO_FILES_FOLDER/jsteg.jpg

###############################
############# PNG #############
###############################

COVER_IMAGE=$COVER_IMAGE_PNG
STEGO_FILES_FOLDER=$STEGO_FILES_FOLDER_PNG

echo ""
echo "Embedding into $COVER_IMAGE now ..."

############# openstego #############

echo ""
echo "... openstego"
openstego embed -mf $SECRET_MESSAGE -cf $COVER_IMAGE -p $PASSPHRASE -sf $STEGO_FILES_FOLDER/openstego.png

############# stegano-lsb #############

echo ""
echo "... stegano-lsb (no passphrase)"
stegano-lsb hide --input $COVER_IMAGE -f $SECRET_MESSAGE -e UTF-8 --output $STEGO_FILES_FOLDER/stegano-lsb.png

############# stegano-lsb-set #############

echo ""
echo "... stegano-lsb-set (no passphrase)"

# Only these four generators work! There are more. Check out `stegano-lsb-set hide -h`
# for GENERATOR in composite eratosthenes identity triangular_numbers; do
#   echo "... stegano-lsb-set --generator $GENERATOR"
#   stegano-lsb-set hide --input $COVER_IMAGE -f $SECRET_MESSAGE -e UTF-8 -g $GENERATOR --output $STEGO_FILES_FOLDER/stegano-lsb-set-$GENERATOR.png
# done

# TODO: reveal currently thows a python error ... check out why `stegano-lsb-set reveal -i stegano-lsb-set-composite.png -e UTF-8 -g composite -o output.txt`

############# stegano-red #############

echo ""
echo "... stegano-red (no passphrase, encoding base64 manually)"
stegano-red hide --input $COVER_IMAGE -m $SECRET_MESSAGE_B64 --output $STEGO_FILES_FOLDER/stegano-red.png

############# cloackedpixel #############

echo ""
echo "... cloackedpixel"
cloackedpixel hide $COVER_IMAGE $SECRET_MESSAGE $PASSPHRASE
mv $COVER_IMAGE-stego.png $STEGO_FILES_FOLDER/cloackedpixel.png

############# LSBSteg #############

echo ""
echo "... LSBSteg"
LSBSteg encode -i $COVER_IMAGE -o $STEGO_FILES_FOLDER/LSBSteg.png -f $SECRET_MESSAGE

###############################
############# WAV #############
###############################

COVER_AUDIO=$COVER_AUDIO_WAV
STEGO_FILES_FOLDER=$STEGO_FILES_FOLDER_WAV

# ############# AudioStego #############

echo ""
echo "... AudioStego/hideme (no passphrase)"
hideme $COVER_AUDIO $SECRET_MESSAGE && mv ./output.wav $STEGO_FILES_FOLDER/hideme.wav

############# steghide #############

echo ""
echo "... steghide"
steghide embed -f -ef $SECRET_MESSAGE -cf $COVER_AUDIO -p $PASSPHRASE -sf $STEGO_FILES_FOLDER/steghide.wav

###############################
############# MP3 #############
###############################

COVER_AUDIO=$COVER_AUDIO_MP3
STEGO_FILES_FOLDER=$STEGO_FILES_FOLDER_MP3

# ############# AudioStego #############

echo ""
echo "... AudioStego/hideme (no passphrase)"
hideme $COVER_AUDIO $SECRET_MESSAGE && mv ./output.mp3 $STEGO_FILES_FOLDER/hideme.mp3

# ############# mp3stego #############

echo ""
echo "... mp3stego - Input = WAV | Output = MP3"
# preprocess WAV file with "bitexact" flag to reduce the chance of mp3stego throwing errors...
TMP_COVER_AUDIO_FILE=/tmp/tmp_cover_audio.wav
ffmpeg -loglevel panic -i $COVER_AUDIO -flags bitexact $TMP_COVER_AUDIO_FILE
mp3stego-encode -E $SECRET_MESSAGE -P $PASSPHRASE $TMP_COVER_AUDIO_FILE $STEGO_FILES_FOLDER_MP3/mp3stego.mp3
rm $TMP_COVER_AUDIO_FILE
