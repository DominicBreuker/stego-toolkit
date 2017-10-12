FROM debian:stretch-20170907

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-utils \
                       forensics-all \
                       foremost \
                       binwalk \
                       exiftool \
                       outguess \
                       pngtools \
                       pngcheck \
                       stegosuite \
                       git \
                       hexedit \
                       python3-pip \
                       python-pip \
                       autotools-dev \
                       automake \
                       libevent-dev \
                       bsdmainutils

RUN pip3 install python-magic

RUN pip install Stegano

COPY install /tmp/install
RUN /tmp/install/stegdetect.sh && \
    /tmp/install/jsteg.sh && \
    /tmp/install/jphide.sh && \
    /tmp/install/outguess-1.3.sh && \
    rm -rf /tmp/install

WORKDIR /data
