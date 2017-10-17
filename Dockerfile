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

RUN pip install tqdm

ENV DEBIAN_FRONTEND noninteractive

COPY install /tmp/install
RUN /tmp/install/jphide.sh && \
    /tmp/install/jsteg.sh && \
    /tmp/install/mp3stego.sh && \
    /tmp/install/openstego.sh && \
    /tmp/install/outguess-1.3.sh && \
    /tmp/install/steg.sh && \
    /tmp/install/steganabara.sh && \
    /tmp/install/stegano.sh && \
    /tmp/install/stegdetect.sh && \
    /tmp/install/stegoVeritas.sh && \
    /tmp/install/stegsolve.sh && \
    /tmp/install/wine.sh && \
    /tmp/install/zsteg.sh && \
    rm -rf /tmp/install

RUN apt-get install -y crunch \
                       cewl \
                       sonic-visualiser

COPY scripts /opt/scripts
ENV PATH="/opt/scripts:${PATH}"

WORKDIR /data
