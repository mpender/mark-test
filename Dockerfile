# Author: Mark Pender
# Purpose: Build a quick and dirty litecoin container image with basic GPG validation 
# Notes: Please review notes in the README.md for basic reasoning 

# See Dockerfile.1 
FROM ubuntu:latest as litecoin-validate

# See Dockerfile.2
LABEL maintainer="mark@email.com"

# See Dockerfile.3
WORKDIR /opt

# See Dockerfile.4
RUN useradd litecoin && \
    apt-get update && \
    apt-get install gpg wget -y && \
    wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz && \
    wget https://download.litecoin.org/litecoin-0.18.1/linux/litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc && \
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-key FE3348877809386C  && \
    gpg --verify litecoin-0.18.1-x86_64-linux-gnu.tar.gz.asc litecoin-0.18.1-x86_64-linux-gnu.tar.gz && \
    tar -xvf litecoin-0.18.1-x86_64-linux-gnu.tar.gz && \           
    rm -rf litecoin-0.18.1-x86_64-linux-gnu.tar.gz && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove && \
    apt-get clean all

# See Dockerfile.5
USER litecoin

FROM alpine  
COPY --from=litecoin-validate /opt/litecoin-0.18.1 /opt/litecoin-0.18.1
#RUN apk --no-cache --update-cache add musl && \
#   addgroup -S litecoin && adduser -S litecoin -G litecoin

ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0
RUN set -ex && \
    apk --update add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib && \
    addgroup -S litecoin && adduser -S litecoin -G litecoin 
USER litecoin
EXPOSE 9333
ENTRYPOINT /opt/litecoin-0.18.1/bin/litecoind -regtest -printtoconsole
