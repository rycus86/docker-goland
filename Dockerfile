FROM debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

ENV GOBIN=/usr/local/go/bin
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go

ARG GO_VERSION=1.16.5
ARG GOLAND_VERSION=2021.1
ARG GOLAND_BUILD=2021.1.3

ARG go_source=https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  curl ca-certificates \
  gcc git openssh-client less \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 libgtk2.0-0 libxslt1.1 libxxf86vm1 \
  && rm -rf /var/lib/apt/lists/* \
  && curl -fsSL $go_source -o /tmp/golang.tar.gz \
  && tar -C /usr/local -xzf /tmp/golang.tar.gz \
  && rm /tmp/golang.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/bin/go \
  && ln -s /usr/local/go/bin/gofmt /usr/bin/gofmt \
  && useradd -ms /bin/bash developer \
  && chown -R developer /usr/local/go

ARG goland_source=https://download.jetbrains.com/go/goland-${GOLAND_BUILD}.tar.gz
ARG goland_local_dir=.GoLand${GOLAND_VERSION}

WORKDIR /opt/goland

RUN curl -fsSL $goland_source -o /opt/goland/installer.tgz \
  && tar --strip-components=1 -xzf installer.tgz \
  && rm installer.tgz

USER developer
ENV HOME /home/developer

RUN mkdir /home/developer/.GoLand \
  && ln -sf /home/developer/.GoLand /home/developer/$goland_local_dir

CMD [ "/opt/goland/bin/goland.sh" ]
