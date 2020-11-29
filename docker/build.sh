#!/bin/bash -e
##
## references:
## https://docs.zephyrproject.org/latest/getting_started/index.html#get-the-source-code
##

export USER="$(whoami)"
export MY_HOME="/home/${USER}"
export BUILDDIR="${MY_HOME}/zephyrproject"
export ZEPHYR_BRANCH="v2.4-branch"


## TODO this may cost performance
sudo chown ${USER}:${USER} -R ${BUILDDIR}

if [[ ! -d "${BUILDDIR}/.west" ]]; then
    cd ${MY_HOME}
    west init ${BUILDDIR}
fi

cd ${BUILDDIR}
west update
west zephyr-export
pip3 install --user -r ${BUILDDIR}/zephyr/scripts/requirements.txt

cd ${BUILDDIR}/zephyr
git checkout ${ZEPHYR_BRANCH}

echo "READY."
echo


### TODO review the former setup script
### prepare SDK environment
##source ~/env.sh
#
##$ cat ./env.sh 
#export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
#export ZEPHYR_SDK_INSTALL_DIR=$HOME/zephyr-sdk-0.10.3
#
### build for reel board
#cd ~/zephyrproject/zephyr
#
### clean
#test -d build && rm -rf build
#
### build
#source zephyr-env.sh
#west build -b reel_board_v2 samples/hello_world
#
### obtain build artifacts
#west flash
#
### debugging
##west debug
#
