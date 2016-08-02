# Configuration-free base from which to build
FROM gliderlabs/alpine:3.4

ENV LANG=C.UTF-8

ARG DOCKER_REPO_VER
ENV DOCKER_REPO_VER=${DOCKER_REPO_VER}

RUN apk update; apk add --upgrade \
        curl \
        tar \
        unzip \
        ca-certificates

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.23-r3" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    wget \
        "https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub" \
        -O "/etc/apk/keys/sgerrand.rsa.pub" && \
    wget \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \
    \
    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" && \
    apk del .build-dependencies && \
    rm \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

# Add Consul from https://releases.hashicorp.com/consul
ENV CONSUL_VER=0.6.4
ENV CONSUL_CHECKSUM=abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627
RUN curl --retry 7 -Lso /tmp/consul.zip \
        "https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_linux_amd64.zip" \
  && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
  && unzip /tmp/consul -d /usr/local/bin \
  && rm /tmp/consul.zip \
  && mkdir /config
# TODO change /config to /etc/consul

# Add Consul template
ENV CONSUL_TEMPLATE_VER=0.14.0
ENV CONSUL_TEMPLATE_CHECKSUM=7c70ea5f230a70c809333e75fdcff2f6f1e838f29cfb872e1420a63cdf7f3a78
RUN curl --retry 7 -Lso /tmp/consul-template.zip \
        "https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VER}/consul-template_${CONSUL_TEMPLATE_VER}_linux_amd64.zip" \
  && echo "${CONSUL_TEMPLATE_CHECKSUM}  /tmp/consul-template.zip" | sha256sum -c \
  && unzip /tmp/consul-template.zip -d /usr/local/bin \
  && rm /tmp/consul-template.zip

# Add Consul web UI
ENV CONSUL_WEB_CHECKSUM=5f8841b51e0e3e2eb1f1dc66a47310ae42b0448e77df14c83bb49e0e0d5fa4b7
RUN curl --retry 7 -Lso /tmp/consul-webui.zip \
        "https://releases.hashicorp.com/consul/${CONSUL_VER}/consul_${CONSUL_VER}_web_ui.zip" \
  && echo "${CONSUL_WEB_CHECKSUM}  /tmp/consul-webui.zip" | sha256sum -c \
  && mkdir /ui && unzip /tmp/consul-webui.zip -d /ui \
  && rm /tmp/consul-webui.zip

# Add Containerpilot and set its configuration
ENV CONTAINERPILOT_VER=2.3.0
ENV CONTAINERPILOT_CHECKSUM=0b2dc36172248d0df3b73ad67c3262ed49096e6c1204e2325b3fd7529617f130
# ENV CONTAINERPILOT=file:///etc/containerpilot/containerpilot.json
RUN curl --retry 7 -Lso /tmp/containerpilot.tar.gz \
        "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
  && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha256sum -c \
  && tar xzf /tmp/containerpilot.tar.gz -C /usr/local/bin \
  && rm /tmp/containerpilot.tar.gz

# DON'T Add our configuration files and scripts
# COPY etc /etc
# COPY bin /usr/local/bin

# EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53 53/udp

# CMD /bin/sh
