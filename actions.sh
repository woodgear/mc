#!/bin/bash

function nvim-init() {
  rm -rf ~/.local/share/nvim/site/pack/*
  ln -s $PWD/.nvim_modules/pack/nvimp ~/.local/share/nvim/site/pack/nvimp
}
function nvim-test() {
  nvim-init
  ../nvim-linux64/bin/nvim --headless --noplugin -u init.test.lua -c "PlenaryBustedDirectory tests {minimal_init = 'tests/init.lua'}"
}

function nvim-build() {
  nvim-init
  #     --headless --noplugin -u ./init.lua
  ../nvim-linux64/bin/nvim --headless --noplugin -u ./serious/init.lua
}

function nvim-run() {
  nvim-init
  #   ../nvim-linux64/bin/nvim  --headless --noplugin -u ./init.lua
  ../nvim-linux64/bin/nvim -u init.lua
}
