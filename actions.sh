#!/bin/bash
function nvim-test() {
  nvim --headless --noplugin -u ./init.test.lua -c "PlenaryBustedDirectory tests {minimal_init = 'tests/init.lua'}"

}

function nvim-install-package() (
  mkdir -p ./.nvim_modules/pack/nvimp/start
  nvim --headless --noplugin -u ./serious/outside.lua
)

function nvim-install() (
  if [ ! -f ./nvim.0.9.2.tar.gz ]; then
    wget https://github.com/neovim/neovim/releases/download/v0.9.2/nvim-linux64.tar.gz -O ./nvim.0.9.2.tar.gz
  fi
  local bingz=./nvim.0.9.2.tar.gz
  mkdir -p ./.nvim
  tar -xvf $bingz -C ./.nvim
  mv ./.nvim/nvim-linux64/* ./.nvim
  rm -rf ./.nvim/nvim-linux64/
)

function nvim-link-dirs() (
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

function nvim-reinstall-with-lock() (
  rm -rf ~/.nvim_modules/
  rm -rf ./.nvim_modules/pack/nvimp/start
  nvim-install-package
)
function nvim-upgrade-all() (
  rm -rf ~/.nvim_modules/
  rm -rf ./.nvim_modules/pack/nvimp/start
  rm ./package.lock
  nvim-install-package
)

function nvim-rm-package() {
  local p=$(ls ~/.nvim_modules | fzf)
  rm -rf ~/.nvim_modules/$p
  rm -rf ./.nvim_modules/pack/nvimp/start/$p
}

function nvim-build() {
  if ! [ -x "$(command -v nvim)" ]; then
    echo "nvim not exist"
    if [ ! -d ./nvim-linux64 ]; then
      nvim-install
    fi
  fi

  nvim-link-dirs
  nvim-install-package()
  echo "init status" $?

  #   nvim-test
}

function nvim-clean-lsp() (
  rm -rf ./.nvim_modules/extra/mason
)

function nvim-check-lsp() (
  nvim --headless --noplugin -u ./serious/outside.lua check-lsp
)

function nvim-run() (
  nvim-link-dirs
)

function nvim-run-docker() (
  nvim-link-dirs
  docker run --rm --name nvim -it m-vim:local bash
)

function nvim-build-docker() (
  docker build -t m-vim:local -f Dockerfile .
)

function nvim-init-formatter() (
  nvim --headless --noplugin -u ./serious/outside.lua init-formatter
)

function mc-log() (
  tail -F ~/.local/share/nvim/mc.vlog.nvim.log
)
