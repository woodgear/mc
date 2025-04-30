#!/bin/bash

function nvim-link-dirs() (
  ln -s $PWD ~/.config/nvim
)

function mc-log() (
  tail -F ~/.local/share/nvim/mc.vlog.nvim.log
)
