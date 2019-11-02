FROM ubuntu:19.04

WORKDIR /root

## resources
## https://docs.zephyrproject.org/latest/getting_started/installation_linux.html
##

RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

## fix missing tzdata setup
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y   tzdata locales

## board support
RUN apt-get install -y   build-essential flex bison libncurses5

## zephyr setup
RUN apt-get install -y   --no-install-recommends git cmake ninja-build gperf \
                         ccache dfu-util device-tree-compiler wget python3-pip \
                         python3-setuptools python3-tk python3-wheel xz-utils \
                         file make gcc gcc-multilib

## (opt) tools for debugging and working
RUN apt-get install -y   vim screen minicom

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


## zephyr SDK
RUN mkdir -p zephyrproject
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
RUN cd ~/zephyrproject && rm -rf zephyr && git clone https://github.com/Rubusch/zephyr.git

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
