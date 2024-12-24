# AstroNvim Template For Termux

**NOTE:** This is for AstroNvim v4+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Install termux required packages

```shell
apt update && yes | apt upgrade && apt update && yes | apt install build-essential termux-api gdu gdb gdbserver gh fd fzf neovim lua-language-server jq-lsp luarocks stylua ripgrep lazygit yarn python python-pip ccls clang rust-analyzer git ruby  && pip install neovim && npm install -g neovim && gem install neovim;
```

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Clone the repository

```shell
git clone https://github.com/remo7777/Astronvim-Termux.git ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```
