FROM ubuntu:20.04
RUN cat /etc/apt/sources.list
# RUN sed -i 's/archive.ubuntu.com/cn.archive.ubuntu.com/g' /etc/apt/sources.list
RUN apt update;
RUN apt-get install -y tzdata
RUN unlink /etc/localtime
RUN ln -s /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt install git file wget tree build-essential sudo python3 golang unzip -y
RUN apt install python3-pip -y
# nodejs should >= 18 required by bash lsp https://github.com/bash-lsp/bash-language-server/issues/474
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=18.16.1
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
COPY . /mc
RUN bash -c 'ls /mc && cd /mc && source ./actions.sh;nvim-build'

