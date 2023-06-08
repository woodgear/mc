FROM ubuntu:20.04
RUN cat /etc/apt/sources.list
RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt update;
RUN apt install git file wget tree build-essential sudo npm golang unzip -y
COPY . /mc
RUN bash -c 'ls /mc && cd /mc && source ./actions.sh;nvim-build'

