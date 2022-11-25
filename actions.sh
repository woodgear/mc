#!/bin/bash

function nvim-init() (
  set -x
  rm -rf ~/.local/share/nvim || true
  mkdir -p ~/.local/share/nvim

  ln -s $PWD/.nvim_modules ~/.local/share/nvim/site

  rm -rf ~/.config/nvim || true
  mkdir -p ~/.config
  ln -s $PWD ~/.config/nvim

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
      rm -rf /usr/bin/nvim
      ln -s $PWD/nvim-linux64/bin/nvim /usr/bin/nvim
      ln -s $PWD/nvim-linux64/bin/nvim /usr/bin/vim
    fi
  fi

  nvim-init
  nvim --headless --noplugin -u ./serious/init.lua
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
