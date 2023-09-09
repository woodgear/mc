#!/bin/bash

function nvim-init-dep() (
  # take a look at dockerfile
  return
)

function nvim-test() {
  nvim --headless --noplugin -u ./init.test.lua -c "PlenaryBustedDirectory tests {minimal_init = 'tests/init.lua'}"
}

function nvim-install() (
  if [ ! -f ./nvim.0.9.2.tar.gz ]; then
    wget https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz -O ./nvim.0.9.2.tar.gz
  fi
  local bingz=./nvim.0.9.2.tar.gz
  tar -xvf $bingz ./nvim
  mv ./.nvim/nvim-linux64/* ./.nvim
  rm -rf ./.nvim/nvim-linux64/
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

  sudo rm -rf /usr/bin/nvim
  sudo rm -rf /usr/bin/vim
  sudo ln -s $PWD/.nvim/bin/nvim /usr/bin/nvim
  sudo ln -s $PWD/.nvim/bin/nvim /usr/bin/vim
)

function nvim-full-clean() {
  rm -rf ./.nvim_modules
  rm -rf ~/.nvim_modules
}

function nvim-build() {
  if ! [ -x "$(command -v nvim)" ]; then
    echo "nvim not exist"
    if [ ! -d ./nvim-linux64 ]; then
      nvim-install
    fi
  fi

  nvim-init
  nvim --headless --noplugin -u ./serious/outside.lua
  echo "init status" $?

  #   nvim-test
}

function nvim-run() (
  nvim-init
)

function nvim-run-docker() (
  nvim-init
  docker run --rm --name nvim -it m-vim:local bash
)

function nvim-build-docker() (
  docker build -t m-vim:local -f Dockerfile .
)

function mc-log() (
  tail -F ~/.local/share/nvim/mc.vlog.nvim.log
)
