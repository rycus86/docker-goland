Docker container to run JetBrains GoLand (https://www.jetbrains.com/go/)

### Usage

```
docker run --rm \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.GoLand:/home/developer/.GoLand \
  -v ~/.GoLand.java:/home/developer/.java \
  -v ~/Project/go:/home/developer/go \
  --security-opt=seccomp:unconfined \
  --name goland-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
rycus86/goland:${IDE_VERSION}
```

Docker Hub Page: https://hub.docker.com/r/rycus86/goland/
([available versions](https://hub.docker.com/r/rycus86/goland/tags))

### OS X instructions

1. Install XQuartz from https://www.xquartz.org/releases/
2. Configure `Allow connections from network clients` in the settings
    - Restart the system (needed only once when this is enabled)
3. Run `xhost +localhost` in a terminal to allow connecting to X11 over the TCP socket
4. Use `-e DISPLAY=host.docker.internal:0` for passing the `${DISPLAY}` environment

#### For Windows hosts (simplified):

```
docker.exe run --rm -d ^
     --name goland ^
     -e DISPLAY=YOUR_IP_ADDRESS:0.0 ^
     -v %TEMP%\.X11-unix:/tmp/.X11-unix ^
     -v %USERPROFILE%\goland:/home/developer ^
     rycus86/goland:%IDE_VERSION%
```

### Notes

You'll still need a license to use the application!

The IDE will have a recent Go version installed.
Project folders need to be mounted like `-v ~/Project/go:/home/developer/go` (`GOPATH` will point to this).
The actual name can be anything - I used something random to be able to start multiple instances if needed.
You might want to consider using `--network=host` if you're running servers from the IDE.
