FROM ubuntu:latest
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
RUN apt update;
RUN apt install git -y

