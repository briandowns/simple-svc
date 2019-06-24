FROM ubuntu:latest

RUN apt-get update &&  \
    apt-get install -y \
        libjson-c-dev  \
        libjansson-dev \
        libyder-dev    \
        liborcania-dev \
        libulfius-dev

EXPOSE 8080:8080
COPY bin/simple-svc /
CMD [ "/simple-svc" ]
