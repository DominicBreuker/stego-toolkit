FROM debian:stretch-20170907

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get install -y apt-utils \
                       forensics-all \
                       foremost \
                       binwalk \
                       exiftool \
                       outguess \
                       pngtools \
                       pngcheck \
                       stegosuite

RUN apt-get install -y git \
                       hexedit
RUN apt-get install -y python3-pip \
                       python-pip

RUN pip3 install python-magic

RUN apt-get install -y autotools-dev \
                       automake \
                       libevent-dev
RUN cd /opt && \
    git clone https://github.com/abeluck/stegdetect && \
    cd /opt/stegdetect && \
    wget -O /opt/stegdetect/file/Magdir/varied.out https://raw.githubusercontent.com/file/file/master/magic/Magdir/varied.out

RUN cd /opt/stegdetect && \
    linux32 ./configure && \
    linux32 make

RUN mv /opt/stegdetect/stegdetect /usr/bin/stegdetect && \
    mv /opt/stegdetect/stegbreak /usr/bin/stegbreak && \
    mv /opt/stegdetect/stegcompare /usr/bin/stegcompare && \
    mv /opt/stegdetect/stegdeimage /usr/bin/stegdeimage && \
    rm -rf /opt/stegbreak

RUN wget -O /usr/bin/jsteg https://github.com/lukechampine/jsteg/releases/download/v0.1.0/jsteg-linux-amd64 && \
    chmod +x /usr/bin/jsteg && \
    wget -O /usr/bin/slink https://github.com/lukechampine/jsteg/releases/download/v0.2.0/slink-linux-amd64 && \
    chmod +x /usr/bin/slink

RUN pip3 install Stegano

RUN apt-get install -y bsdmainutils

WORKDIR /data
