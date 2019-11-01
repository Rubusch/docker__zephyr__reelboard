#!/bin/bash -e
##
## resources:
## https://docs.zephyrproject.org/latest/getting_started/index.html#get-the-source-code
##
##
## started with:
## $ docker run -ti -v $PWD/mnt:$(pwd)/output afb489d932bc
##

## prepare SDK environment
source ~/env.sh

## TODO rm
#export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
#export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-0.10.3

# ## set up 'unset preset flags' command script
# echo 'unset CFLAGS CXXFLAGS' >> /etc/profile.d/unset_cflags.sh
#
# ## TODO shift this to docker file?
# ## install zephyr sources
# pip3 install west
#
# ## clone zephyr repository
# west init zephyrproject
# cd zephyrproject
# west update
#
# ## install python dependencies
# pip3 install -r zephyr/scripts/requirements.txt
   
## zephyr setup
#cd ~/zephyrproject
#west init --mr=v1.14.1 ~/zephyrproject
#west update
#pip3 install -r zephyr/scripts/requirements.txt


# TODO rm   
## build hello world
#cd ~/zephyrproject/zephyr
#source zephyr-env.sh
#west build -b reel_board samples/hello_world

## TODO check to keep this here, or move into Dockerfile
echo 'ATTR{idProduct}=="0204", ATTR{idVendor}=="0d28", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/50-cmsis-dap.rules
udevadm control --reload-rules

## build for reel board
cd ~/zephyrproject
source ~/env.sh
west build -b reel_board_v2 zephyr/samples/hello_world

## obtain build artifacts
west flash --erase
