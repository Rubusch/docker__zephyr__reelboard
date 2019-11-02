#!/bin/bash -e
##
## resources:
## https://docs.zephyrproject.org/latest/getting_started/index.html#get-the-source-code
##

## prepare SDK environment
source ~/env.sh

## build for reel board
cd ~/zephyrproject/zephyr
source zephyr-env.sh
west build -b reel_board_v2 samples/hello_world

## obtain build artifacts
west flash
