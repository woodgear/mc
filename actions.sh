#!/bin/bash

function nvim-init-dep() (
  sudo apt update
  sudo apt install git file wget tree build-essential pip npm golang unzip -y
)
function nvim-init() (
  set -x
  rm -rf ~/.local/share/nvim || true
  mkdir -p ~/.local/share/nvim

  ln -s $PWD/.nvim_modules ~/.local/share/nvim/site

  rm -rf ~/.config/nvim || true
  mkdir -p ~/.config
  ln -s $PWD ~/.config/nvim
  # require  pip
  ls -alh ~/.config/nvim
  ls -alh ~/.local/share/nvim/site
)

function nvim-test() {
  nvim-init
  nvim --headless --noplugin -u ./init.test.lua -c "PlenaryBustedDirectory tests {minimal_init = 'tests/init.lua'}"
}

function nvim-build() {
  if ! [ -x "$(command -v nvim)" ]; then
    echo "nvim not exist"
    if [ ! -d ./nvim-linux64 ]; then
      echo "local nvim not exist"
      wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
      tar -xf nvim-linux64.tar.gz
      rm ./nvim-linux64.tar.gz
    fi
    sudo rm -rf /usr/bin/nvim
    sudo rm -rf /usr/bin/vim
    sudo ln -s $PWD/nvim-linux64/bin/nvim /usr/bin/nvim
    sudo ln -s $PWD/nvim-linux64/bin/nvim /usr/bin/vim
  fi

  nvim-init
  nvim --headless --noplugin -u ./serious/outside.lua
}

function nvim-run() (
  nvim-init
)

function nvim-run-docker() (
  nvim-init
  docker run --rm --name nvim -v $PWD:/mc -it m-vim:local bash
)

function nvim-build-docker() (
  docker build -t m-vim:local -f Dockerfile .
)
