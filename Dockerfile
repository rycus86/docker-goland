FROM --platform=${TARGETPLATFORM} debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  gcc git openssh-client less curl ca-certificates \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/*

ENV GOBIN=/usr/local/go/bin
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go

ARG TARGETARCH
ARG GO_VERSION=1.20.4

RUN  \
  export GO_SOURCE="https://dl.google.com/go/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz" \
  && curl -fsSL ${GO_SOURCE} -o /tmp/golang.tar.gz \
  && tar -C /usr/local -xzf /tmp/golang.tar.gz \
  && rm /tmp/golang.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/bin/go \
  && ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt \
  && useradd -ms /bin/bash developer \
  && chown -R developer /usr/local/go

ARG GOLAND_VERSION=2023.1
ARG GOLAND_BUILD=2023.1.2
ARG goland_local_dir=.GoLand${GOLAND_VERSION}

WORKDIR /opt/goland

RUN echo "Preparing Goland ${GOLAND_BUILD} ..." \
  && if [ "$TARGETARCH" = "arm64" ]; then export goland_arch='-aarch64'; else export goland_arch=''; fi \
  && export goland_source=https://download.jetbrains.com/go/goland-${GOLAND_BUILD}${goland_arch}.tar.gz \
  && echo "Downloading ${goland_source} ..." \
  && curl -fsSL $goland_source -o /opt/goland/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.GoLand \
  && ln -sf /home/developer/.GoLand /home/developer/$goland_local_dir

CMD [ "/opt/goland/bin/goland.sh" ]
