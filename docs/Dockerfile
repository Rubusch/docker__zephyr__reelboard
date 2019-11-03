FROM alpine:3.10

MAINTAINER Lothar Rubusch <lotophagon@protonmail.com>
WORKDIR /root


RUN apk update

RUN apk add \
    tzdata \
    build-base \
    flex \
    bison \
    ncurses-libs \
    bash

## zephyr setup
RUN apk add \
    git \
    cmake \
    ninja \
    gperf \
    ccache \
    dtc \
    wget \
    python3-tkinter \
    py3-cryptography \
    py3-setuptools \
    xz \
    file \
    make \
    gcc

## hack: packages from testing
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    dfu-util

# FIXME: pip then will fail to build cmsis-pack-manager, some dependencies in the pip3 setup seem to be buggy with alpine 3.10 still

## omitted packages:
# no py-pip (python2 and not 3)
# py3-setuptools (done by the pip hack anyway)
# no gcc-multilib (debian multilib not in alpine)
# no python3-wheel (whl is not supported in alpine, use pip)

## hack: python3 packages
## (python3-pip and python3-setuptools)
##
## resource: https://github.com/Docker-Hub-frolvlad/docker-alpine-python3/blob/master/Dockerfile
ENV PYTHONUNBUFFERED=1
RUN echo "**** install Python ****" && \
    apk add --no-cache python3 && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    \
    echo "**** install pip ****" && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

## (opt) tools for debugging and working
RUN apk add \
    vim \
    screen \
    minicom

## zephyr SDK
RUN mkdir -p /root/zephyrproject

RUN cd zephyrproject && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.3/zephyr-sdk-0.10.3-setup.run && \
    chmod +x zephyr-sdk-0.10.3-setup.run && \
    ./zephyr-sdk-0.10.3-setup.run -- -d ~/zephyr-sdk-0.10.3

## set up 'unset preset flags' command script
RUN echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh


################################################################################
## get zephyr sources via west (regular way to install)

RUN pip3 install west
RUN west init zephyrproject
RUN cd ~/zephyrproject && west update

## (opt) use my own branch
#RUN cd ~/zephyrproject && rm -rf zephyr && git clone https://github.com/Rubusch/zephyr.git

## continue zephyr sources installation
RUN cd ~/zephyrproject && pip3 install -r zephyr/scripts/requirements.txt


################################################################################
## specific: PHYTEC reel board settings


################################################################################
## build command automation
COPY env.sh /root/env.sh
COPY build.sh /root/build.sh

## automatic execution in command mode
CMD ["/bin/bash", "/root/build.sh"]
