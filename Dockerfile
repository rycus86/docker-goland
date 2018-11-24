FROM debian

LABEL maintainer "Viktor Adam <rycus86@gmail.com>"

ARG go_source=https://dl.google.com/go/go1.10.linux-amd64.tar.gz

ADD $go_source /tmp/golang.tar.gz
RUN tar -C /usr/local -xzf /tmp/golang.tar.gz && rm /tmp/golang.tar.gz

ENV GOBIN=/usr/local/go/bin
ENV GOROOT=/usr/local/go
ENV GOPATH=/root/go

RUN  \
  apt-get update && apt-get install --no-install-recommends -y \
  curl ca-certificates \
  gcc git openssh-client \
  libxtst-dev libxext-dev libxrender-dev libfreetype6-dev \
  libfontconfig1 \
  && rm -rf /var/lib/apt/lists/*

ARG goland_source=https://download-cf.jetbrains.com/go/goland-2018.1.7.tar.gz
ARG goland_local_dir=.GoLand2018.1

RUN mkdir /opt/goland
WORKDIR /opt/goland

ADD $goland_source /opt/goland/installer.tgz

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

RUN tar --strip-components=1 -xzf installer.tgz && rm installer.tgz
RUN curl -fsSL https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

RUN useradd -ms /bin/bash developer
USER developer

ENV HOME /home/developer

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

RUN mkdir /home/developer/.GoLand \
  && ln -sf /home/developer/.GoLand /home/developer/$goland_local_dir

CMD [ "/opt/goland/bin/goland.sh" ]
