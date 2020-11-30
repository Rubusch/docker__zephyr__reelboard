# docker__zephyr__phytec-reelboard

Contains a Dockerfile for building an docker image and its container for zephyr.  

![Reelboard Setup](pics/reelboard.jpg)

Setup for _PHYTEC_ **reel board board v2** (display ribbon cable shows: HINK-E0213**A22**)  

![Serial Number](pics/serialnumber.jpg)

Implicitely will run ```git clone https://github.com/Rubusch/zephyr.git``` inside the docker container.  



## References

https://docs.zephyrproject.org/latest/boards/arm/reel_board/doc/index.html
https://www.phytec.eu/product-eu/internet-of-things/reelboard/



## Build

```
$ cd ./docker/
$ time docker build --build-arg USER=$USER -t rubuschl/zephyr-reelboard:$(date +%Y%m%d%H%M%S) .
```

(opt) Append ``--no-cache`` for really re-building the container, which may fix some build bugs  


## Usage

In case of Tag **20191104161353**, enter the container or simply build leaving out the ``/bin/bash``  

```
$ docker images
    REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/zephyr-reelboard    20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ...

$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER --device=/dev/ttyACM0 -v $PWD/configs:/home/$USER/configs -v $PWD/zephyr:/home/$USER/zephyrproject/zephyr rubuschl/zephyr-reelboard:20191104161353 /bin/bash
```

Make sure the device is plugged (/dev/ttyACM0 exists)  
(opt) Appending ``--privileged`` is not _safe_, the docker container is supposed rather to allow for archiving of the toolchain  
(opt) Append ``/bin/bash`` to enter the current container for debugging  


## Target

Building the board support package (bsp) for the target, e.g. the reel board board v2  

```
docker $> ./build.sh
```

NB: Make sure, after re-login also execute ``build.sh`` or at least fix all python dependencies are around (TODO improve this?)  
```
docker $> cd ~/zephyrproject/zephyr
docker $> pip3 install -r /home/user/zephyrproject/zephyr/scripts/requirements.txt
```

Build an example  

```
docker $> cd ~/zephyrproject/zephyr
docker $> west build -p auto -b reel_board_v2 samples/basic/blinky
```

(opt) Provide an udev rule  

```
docker $> echo 'ATTR{idProduct}=="0204", ATTR{idVendor}=="0d28", MODE="0666", GROUP="plugdev"' | sudo tee -a /etc/udev/rules.d/50-cmsis-dap.rules
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

Use the /dev/ttyACM0 device for debugging the target  
