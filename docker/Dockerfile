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

## debugging
#RUN apt-get install -y   vim screen


## NOTE
# A recent DTC version (1.4.6 or higher) is required. Check what version you
# have by using dtc --version. If you have an older version, either install a
# more recent one by building from source, or use the one that is bundled in
# the Zephyr SDK by installing it and setting the ZEPHYR_SDK_INSTALL_DIR
# environment variable.

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


## SDK # TODO check, needed?
RUN mkdir -p zephyrproject
RUN cd zephyrproject && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.10.3/zephyr-sdk-0.10.3-setup.run && \
    chmod +x zephyr-sdk-0.10.3-setup.run && \
    ./zephyr-sdk-0.10.3-setup.run -- -d ~/zephyr-sdk-0.10.3


## installation
#ENV ZEPHYR_TOOLCHAIN_VARIANT=zephyr
#ENV ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-0.10.3

## set up 'unset preset flags' command script
#RUN echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh


################################################################################
## get system via west

## install west
RUN pip3 install west

## zephyr setup
RUN west init zephyrproject
RUN cd ~/zephyrproject && west update
RUN cd ~/zephyrproject && pip3 install -r zephyr/scripts/requirements.txt


#COPY gcc-arm-none-eabi-8-2019-q3-update-linux-pt1.tar.xz /root/gcc-arm-none-eabi-8-2019-q3-update-linux-pt1.tar.xz
#RUN cd ~/zephyrproject && tar -xvJf ~/gcc-arm-none-eabi-8-2019-q3-update-linux-pt1.tar.xz

#COPY gcc-arm-none-eabi-8-2019-q3-update-linux-pt2.tar.xz /root/gcc-arm-none-eabi-8-2019-q3-update-linux-pt2.tar.xz
#RUN cd ~/zephyrproject && tar -xvJf ~/gcc-arm-none-eabi-8-2019-q3-update-linux-pt2.tar.xz

#COPY JLink_Linux_V644e_x86_64.deb /root/JLink_Linux_V644e_x86_64.deb
#RUN dpkg -i ~/JLink_Linux_V644e_x86_64.deb

#COPY nRF-Command-Line-Tools_10_3_0_Linux-amd64.deb /root/nRF-Command-Line-Tools_10_3_0_Linux-amd64.deb
#RUN dpkg -i ~/nRF-Command-Line-Tools_10_3_0_Linux-amd64.deb

#RUN git clone --branch v1.4.7 https://git.kernel.org/pub/scm/utils/dtc/dtc.git ~/zephyrproject/dtc
#RUN cd ~/zephyrproject/dtc && make && make install


COPY env.sh /root/env.sh

COPY build.sh /root/build.sh

################################################################################
## get sources & CO w/o 'west'
#RUN mkdir zephyrproject
#RUN cd zephyrproject && git clone -j4 https://github.com/Rubusch/zephyr.git
# TODO set ZEPHYR_MODULES in .zephyrrc
# TODO set ZEPHYR_EXTRA_MODULES in .zephyrrc
# cmake -DZEPHYR_MODULES=<path-to-module1>[;<path-to-module2>[...]] ...
## alternativamente insert
#set(ZEPHYR_MODULES <path-to-module1> <path-to-module2> [...])
#include($ENV{ZEPHYR_BASE}/cmake/app/boilerplate.cmake NO_POLICY_SCOPE)
##
## Put this in a file with a name like "zephyr-modules.cmake"
#set(ZEPHYR_MODULES <path-to-module1> <path-to-module2>
#  CACHE STRING "pre-cached modules")
## ...and call cmake with
## -C zephyr-modules.cmake

## build application (in script)
CMD ["/bin/bash", "/root/build.sh"]
