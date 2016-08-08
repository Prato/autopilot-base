# Configuration-free base from which to build
# FROM gliderlabs/alpine:3.4
FROM scratch

# ADD rootfs.tar.xz /
ENV ALPINE_VER=3.4
ENV ALPINE_SHA=45ba65c1116aaf668f7ab5f2b3ae2ef4b00738be
ADD https://github.com/gliderlabs/docker-alpine/raw/${ALPINE_SHA}/versions/library-${ALPINE_VER}/rootfs.tar.gz /
# meta: http://alpine.gliderlabs.com/alpine/latest-stable/releases/x86_64/latest-releases.yaml
# export ALPINE_SHA256=72ef748775f803c7722f005db155af998410736e5bfd6cfb37d5a1c01f170d26




CMD ["/bin/bash"]
