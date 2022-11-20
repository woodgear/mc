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
  local nvim="../nvim-linux64/bin/nvim"
  local nvim="nvim"
  $nvim --headless --noplugin -u ./init.test.lua -c "PlenaryBustedDirectory tests {minimal_init = 'tests/init.lua'}"
}

function nvim-docker-init-nvim() {
  ln -s $PWD/../nvim-linux64/bin/nvim /bin
}

function nvim-build() {
  nvim-init
  local nvim="../nvim-linux64/bin/nvim"
  local nvim="nvim"
  $nvim --headless --noplugin -u ./serious/init.lua
}

function nvim-run-docker() (
  nvim-init
  cd ../
  docker run -v $PWD:/test-nvim -it ubuntu bash
)

function nvim-build-docker() (
  docker build -t m-vim:local -f Dockerfile .
)
