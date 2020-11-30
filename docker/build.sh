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
if [[ ! -d ${BUILDDIR}/zephyr ]]; then
    ## get zephyr sources, if there is nothing
    echo "get zephyr sources..."
    cd ${BUILDDIR} && rm -rf zephyr && git clone https://github.com/Rubusch/zephyr.git
    cd ${BUILDDIR}/zephyr
    git checkout ${ZEPHYR_BRANCH}
else
    echo "zephyr sources found"
fi

echo "READY."
echo
