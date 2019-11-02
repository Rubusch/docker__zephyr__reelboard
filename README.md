# docker__zephyr

Contains a Dockerfile for building an docker image and its container for zephyr.

Setup for _PHYTEC_ **reel board board v2** (display ribbon cable shows: HINK-E0213**A22**)

Implicitely will run ```git clone https://github.com/Rubusch/zephyr.git``` inside the docker container.



## Resources

https://docs.zephyrproject.org/latest/boards/arm/reel_board/doc/index.html
https://www.phytec.eu/product-eu/internet-of-things/reelboard/



## Build

```
$ cd ./docker/
$ time docker build --no-cache --tag 19.04 -t rubuschl:zephyr-reelboardv2 .
$ time docker run -ti --rm -v $PWD/output:/mnt rubuschl:zephyr-reelboardv2
```


## Debug

**NOTE**: privileged mode is not _safe_, the docker container is supposed rather to allow for archiving of the toolchain


```
$ docker run -ti --privileged -v $PWD/output:/mnt rubuschl:zephyr-reelboardv2 /bin/bash
docker $>
```


## Target

Building the board support package (bsp) for the target, e.g. the nRF52 PCA10040 eval board

```
docker $> ./build.sh
docker $> source ~/env.sh
docker $> cd ~/zephyrproject
docker $> west build -b reel_board_v2 samples/hello_world
```

Prepare flashing the target

```
docker $> echo 'ATTR{idProduct}=="0204", ATTR{idVendor}=="0d28", MODE="0666", GROUP="plugdev"' > /etc/udev/rules.d/50-cmsis-dap.rules
docker $> udevadm control --reload-rules
```

Setup any serial console, e.g.

```
docker $> minicom -D <tty_device> -b 115200
```

Flash the target
```
docker $> west flash --erase
```

(opt) Debug the target
```
docker $> west debug
```

Use the /dev/ttyACM0 device for debugging the target.
