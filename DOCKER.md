# Linux-Fake-Background-Webcam with Docker

Note that on my machine the CPU-version can be used instantaneously while the GPU-version
needs around 5 minutes until it is available (to be more precise: the bodypix-container).
However, the GPU-version is more potent when finally running.

## Configuration

Docker-Compose will automatically read/create environment variables from an [.env-file](https://docs.docker.com/compose/environment-variables/#the-env-file)

So just copy the provided default-file and modify as needed:
```shell script
cp defaults.env .env
```

## Docker Compose (CPU)

### Prerequisites

* v4l2loopback
* docker
* docker-compose 

### Usage

 - Run and initial build containers: ``docker-compose up`` (or ``docker-compose up -d``)
 - Stop and remove containers: ``docker-compose down``
 - Note: *Ctrl-C* is currently stops the containers instead of changing images

## Docker (GPU)

### Prerequisites

* v4l2loopback
* docker
* docker-compose >= 1.27.0 (to support the `runtime` configuration in the docker-compose file)
* [Nvidia Docker](https://github.com/NVIDIA/nvidia-docker#quickstart)

### Using docker-compose

Works similar to the CPU-version, but you have to provide the docker-compose filename to use.

```bash
docker-compose -f docker-compose-gpu.yml up
```

When you stop the services make sure to delete the volumes too!
```bash
docker-compose -f docker-compose-gpu.yml down --volumes
```

If you only want to switch the image (i.e. make changes in the `.env` file), you can just "restart"
the fakecam-container:
```shell script
docker-compose -f docker-compose-gpu.yml stop fakecam-gpu
docker-compose -f docker-compose-gpu.yml up -d fakecam-gpu
```

## Manual via docker only

Build Images:

```bash
docker build -t bodypix -f ./bodypix/Dockerfile-gpu ./bodypix
docker build -t fakecam ./fakecam
```

Create a Network:

```bash
docker network create --driver bridge fakecam
```

Create a Volume:

```bash
docker volume create --name fakecam
```

Start the bodypix app with GPU support and listen on a UNIX socket:

```bash
docker run -d \
  --rm \
  --name=bodypix \
  --network=fakecam \
  -v fakecam:/socket \
  -e PORT=/socket/bodypix.sock \
  --gpus=all --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 \
  bodypix
```

Start the camera, note that we need to pass through video devices,
and we want our user ID and group to have permission to them
you may need to `sudo groupadd $USER video`:

```bash
docker run -d \
  --rm \
  --name=fakecam \
  --network=fakecam \
  --device=/dev/video2:/dev/video0 \
  --device=/dev/video11:/dev/video2 \
  -v fakecam:/socket \
  fakecam \
  -B /socket/bodypix.sock --no-foreground --scale-factor 1
```

After you've finished, clean up:

```bash
docker rm -f fakecam bodypix
docker volume rm fakecam
docker network rm fakecam
```
