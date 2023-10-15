# ----------------------------------
# Trillion Servers Custom Docker Image
# ----------------------------------


FROM debian:bullseye-slim

LABEL author="Griffindor" maintainer="griffin@trillionservers.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt upgrade -y
RUN apt install -y curl wget jq unzip libc6-dev libx11-dev lib32gcc-s1 musl-dev
RUN useradd -d /home/container -m container
RUN ln -s /usr/lib/x86_64-linux-musl/libc.so /lib/libc.musl-x86_64.so.1

USER container
ENV  USER container
ENV  HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
