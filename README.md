Docker container to run JetBrains GoLand (https://www.jetbrains.com/go/)

### Usage

```
docker run --rm \
  -e DISPLAY=${DISPLAY} \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.GoLand:/home/developer/.GoLand2018.1 \
  -v ~/.GoLand.java:/home/developer/.java \
  -v ~/Project/go:/home/developer/go \
  --security-opt=seccomp:unconfined \
  --name goland-$(head -c 4 /dev/urandom | xxd -p)-$(date +'%Y%m%d-%H%M%S') \
rycus86/goland:latest
```

__Note__: you'll still need a license to use the application.

Docker Hub Page: https://hub.docker.com/r/rycus86/goland/

### Notes

The IDE will have Go and dep installed.
Project folders need to be mounted like `-v ~/Project/go:/home/developer/go` (`GOPATH` will point to this).
The actual name can be anything - I used something random to be able to start multiple instances if needed.
You might want to consider using `--network=host` if you're running servers from the IDE.
