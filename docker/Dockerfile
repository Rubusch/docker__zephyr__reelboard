FROM debian:testing
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER="${USER}"

#ARG ZEPHYR_BRANCH="reel-board"
ARG ZEPHYR_BRANCH="v2.4-branch"
ARG ZEPHYR_SDK_VERSION="0.11.4"


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge

## basic build and container setup
RUN apt-get install -y   \
    tzdata \
    locales \
    build-essential \
    flex \
    bison \
    libncurses5 \
    udev

## zephyr setup
RUN apt-get install -y --no-install-recommends \
    git \
    cmake \
    ninja-build \
    gperf \
    ccache \
    dfu-util \
    device-tree-compiler \
    wget \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-tk \
    python3-wheel \
    xz-utils \
    file \
    make \
    gcc \
    gcc-multilib \
    g++-multilib \
    libsdl2-dev \
    gnutls-bin

## (opt) tools for debugging and working
RUN apt-get install -y   \
    vim \
    screen \
    minicom \
    libpython2.7 \
    sudo \
    tree \
    colordiff \
    htop


################################################################################
## setup user and run stuff under user
RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8


################################################################################
## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers


################################################################################
## specific: board settings

## bash config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.bashrc" && sudo su $USER -c "ln -s /home/$USER/configs/.bashrc /home/$USER/"

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/configs/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/configs/.emacs /home/$USER/"

## git config
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.st status"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.ci commit"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.co checkout"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.br branch"
RUN cd /home/$USER && sudo su $USER -c "git config --global http.sslVerify false"
RUN cd /home/$USER && sudo su $USER -c "git config --global http.postBuffer 1048576000"

RUN chown $USER:$USER -R /home/$USER


################################################################################
## zephyr SDK

## prepare environment
RUN cd /home/$USER && sudo su $USER -c "mkdir -p /home/$USER/zephyrproject"
RUN ln -s /usr/local /home/$USER/.local && chown $USER:$USER -R /usr/local
RUN mkdir -p /home/$USER/.local/bin && chown $USER:$USER -R /home/$USER/.local


## setup west in 'zephyrproject'
RUN cd /home/$USER && sudo su $USER -c "export PATH=/home/${USER}/.local/bin:${PATH} && pip3 install --user -U west"
RUN cd /home/$USER/ && sudo su $USER -c "west init zephyrproject"
RUN cd /home/$USER/zephyrproject && sudo su $USER -c "west update"
RUN cd /home/$USER/zephyrproject && sudo su $USER -c "west zephyr-export"

### (1/2) use zephyr sources to install python requirements, then remove it again (will be mounted from outside)
#RUN rm -rf /home/$USER/zephyrproject/zephyr && cd /home/$USER/zephyrproject && sudo su $USER -c "git clone --branch ${ZEPHYR_BRANCH} https://github.com/Rubusch/zephyr.git"

RUN cd /home/$USER/zephyrproject && sudo su $USER -c "pip3 install --user -r zephyr/scripts/requirements.txt"

### (2/2)
RUN rm -rf /home/$USER/zephyrproject/zephyr

## zephyr toolchain - NB: the following typically fails with 'Error in the pull function' behind a tunneled connection
RUN cd /home/$USER && sudo su $USER -c "wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run"
RUN cd /home/$USER && sudo su $USER -c "chmod +x zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run"
RUN cd /home/$USER && sudo su $USER -c "./zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run -- -d /usr/local/zephyr-sdk-${ZEPHYR_SDK_VERSION}"
RUN cd /home/$USER && sudo su $USER -c "rm -rf ./zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run"
#RUN cd /home/$USER && sudo su $USER -c "sudo cp ~/zephyr-sdk-${ZEPHYR_SDK_VERSION}/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d"
#RUN cd /home/$USER && sudo su $USER -c "sudo udevadm control --reload"

### (opt) set up 'unset preset flags' command script
RUN echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]




# TODO rm       
#################################################################################
### zephyr SDK
#ARG ZEPHYR_SDK_VERSION=0.10.3
#
#RUN mkdir -p /home/$USER/zephyrproject
#
#RUN cd /home/$USER/zephyrproject && wget https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZEPHYR_SDK_VERSION}/zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run
#RUN cd /home/$USER/zephyrproject && chmod +x zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run
#RUN cd /home/$USER/zephyrproject && ./zephyr-sdk-${ZEPHYR_SDK_VERSION}-setup.run -- -d /home/$USER/zephyr-sdk-${ZEPHYR_SDK_VERSION}
#
### set up 'unset preset flags' command script
#RUN echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh
#
#
#################################################################################
### get zephyr sources via west (regular way to install)
#
#RUN pip3 install west
#RUN cd /home/$USER/ && west init zephyrproject
#RUN cd /home/$USER/zephyrproject && west update
#
### (opt) use my own branch
#RUN cd /home/$USER/zephyrproject && rm -rf zephyr && git clone https://github.com/Rubusch/zephyr.git
#
### continue zephyr sources installation
#RUN cd /home/$USER/zephyrproject && pip3 install -r zephyr/scripts/requirements.txt
#
#
#################################################################################
### specific: PHYTEC reel board settings
#
#RUN chown $USER:$USER -R /home/$USER
#
#
#################################################################################
### command mode
#COPY env.sh /home/$USER/env.sh
#COPY build.sh /usr/local/bin/build.sh
#CMD ["/bin/bash", "/usr/local/bin/build.sh"]
