FROM ubuntu:latest
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt update;
RUN apt install git file wget tree build-essential sudo npm golang unzip -y
COPY . /mc
RUN bash -c 'ls /mc && cd /mc && source ./actions.sh;nvim-build'

