# AstroNvim Termux Setup 🚀

A pre-configured, mobile-optimized [AstroNvim](https://github.com/AstroNvim/AstroNvim) **v6+** setup tailored specifically for **Termux (Android)** and **Linux** environments.

This configuration uses native binary detection to bypass Mason binary compatibility issues on Termux, providing high-performance LSP servers, Treesitter parsers, and None-LS formatters.

---

## 📋 Table of Contents

- [Supported Languages & LSPs](#-supported-languages--lsps)
- [System Requirements & Dependencies](#-system-requirements--dependencies)
- [Step-by-Step Installation Guide](#-step-by-step-installation-guide)
  - [Step 1: Update & Install Termux Packages](#step-1-update--install-termux-packages)
  - [Step 2: Install Global npm & LuaRocks Packages](#step-2-install-global-npm--luarocks-packages)
  - [Step 3: Install Cargo Packages (TeXLab)](#step-3-install-cargo-packages-texlab)
  - [Step 4: Update Shell PATH](#step-4-update-shell-path)
  - [Step 5: Backup Existing Neovim Configuration](#step-5-backup-existing-neovim-configuration)
  - [Step 6: Clone Configuration Repository](#step-6-clone-configuration-repository)
  - [Step 7: Launch Neovim](#step-7-launch-neovim)
- [Verification & Health Check](#-verification--health-check)

---

## 🛠 Supported Languages & LSPs

| Language / Filetype | Language Server (LSP) | Formatter / Linter | Binary Source |
| :--- | :--- | :--- | :--- |
| **Lua** | `lua_ls` | `stylua` | Termux `pkg` |
| **Bash / Shell** | `bashls` | `shfmt` | `npm` / Termux `pkg` |
| **C / C++ / ObjC** | `clangd` / `ccls` | `clang-format` | Termux `pkg` |
| **Rust** | `rust_analyzer` | `cargo fmt` | Termux `pkg` / Cargo |
| **LaTeX / TeX** | `digestif` / `texlab` | Native TeX | LuaRocks / Cargo |
| **JSON / JQ** | `jq_lsp` | `prettier` | Termux `pkg` / `npm` |
| **Fish Shell** | `fish_lsp` | `fish_indent` | Local / Termux `pkg` |

---

## ⚙️ System Requirements & Dependencies

Before setting up this configuration on a fresh Termux / Linux installation, make sure all compiler toolchains and required language servers are installed.

---

## 📥 Step-by-Step Installation Guide

### Step 1: Update & Install Termux Packages

Run the following command in Termux to install Neovim, compilers, development tools, and native LSP packages:

```bash
pkg update && pkg upgrade -y
pkg install -y \
  git \
  neovim \
  build-essential \
  clang \
  ccls \
  rust \
  rust-analyzer \
  lua-language-server \
  luarocks \
  nodejs-lts \
  python \
  jq \
  fish \
  shfmt \
  stylua \
  tree-sitter \
  texinfo \
  texlab \
  tectonic
```

> **Note on `fish_indent` & Fish Shell:**  
> `fish_indent` (and `fish` diagnostics) comes pre-packaged with the `fish` shell. Installing `pkg install fish` in Step 1 automatically installs `fish_indent` at `/data/data/com.termux/files/usr/bin/fish_indent`. `none-ls` in this configuration automatically detects it for formatting `.fish` files.

> **Note on C/Rust Native Compilations (`ndk-multilib`):**  
> If you are compiling C/C++ or Rust libraries that link directly against Android NDK native shared libraries (like `liblog`, `libandroid`, `libvulkan`), install NDK native stubs via:  
> `pkg install ndk-multilib ndk-multilib-native-stubs`

### Step 2: Install Global npm & LuaRocks Packages (Including `fish-lsp`)

Install Node.js based LSPs/formatters, `fish-lsp`, and the Lua-based TeX LSP (`digestif`):

```bash
# Install bash language server, prettier, and fish-lsp globally via npm
npm install -g bash-language-server prettier @fish-lsp/fish-lsp

# Install digestif (LaTeX LSP) via LuaRocks
luarocks install digestif
```

> **Alternative (`fish-lsp` from Source):**  
> If you prefer building `fish-lsp` from source instead of global npm:
> ```bash
> git clone https://github.com/fish-lsp/fish-lsp.git ~/fish-lsp
> cd ~/fish-lsp && npm install && npm run build
> mkdir -p ~/.config/fish/completions
> cp fish_files/fish-lsp.fish ~/.config/fish/completions/
> ```

### Step 3: TeXLab LSP (Included via Termux `pkg`)

`texlab` is included directly via `pkg install texlab` in Step 1.

> **Optional (Cargo Build):** If you prefer building the latest `texlab` from source via Cargo:
> ```bash
> cargo install texlab
> ```

### Step 4: Update Shell PATH

Ensure your shell (`.bashrc` or `.zshrc` or `config.fish`) includes `~/.cargo/bin` and `~/.local/bin` in your environment `PATH`.

Add the following to `~/.bashrc`:

```bash
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"
```

Apply changes immediately:

```bash
source ~/.bashrc
```

### Step 5: Backup Existing Neovim Configuration

If you have an existing Neovim configuration, back it up first:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

### Step 6: Clone Configuration Repository

Clone this repository into `~/.config/nvim`:

```bash
git clone https://github.com/remo7777/Astronvim-Termux ~/.config/nvim
```

### Step 7: Launch Neovim

Start Neovim for the first time. Plugins will automatically download and install via `lazy.nvim`:

```bash
nvim
```

---

## 🔍 Verification & Health Check

Inside Neovim, verify that all plugins and LSPs are installed properly:

```vim
:checkhealth
:LspInfo
```

To test loaded AstroLSP server status from the command line:

```bash
nvim --headless +":lua print(vim.inspect(require('astrolsp').config.servers))" +q
```

---

## ⚡ Building `blink.cmp` Natively on Termux (`libblink_cmp_fuzzy.so`)

`blink.cmp` uses a C/Rust dynamic shared library (`libblink_cmp_fuzzy.so`) for ultra-fast fuzzy completion matching. Precompiled glibc binaries fail on Android/Termux, so it must be built natively using Cargo.

### Requirements
- **Rust Compiler & Toolchain**: `pkg install rust build-essential git`

### Manual Build Steps

```bash
# 1. Navigate to the blink.cmp plugin directory in Lazy:
cd ~/.local/share/nvim/lazy/blink.cmp

# 2. Build the shared library using Cargo:
cargo build --release

# 3. Verify the generated shared library:
ls -lh target/release/libblink_cmp_fuzzy.so
```

### Lazy.nvim Automatic Build Specification

In your Neovim plugin setup, force `lazy.nvim` to build the Rust library natively on update:

```lua
{
  "Saghen/blink.cmp",
  build = "cargo build --release",
  opts = {
    -- Your blink.cmp configuration options
  },
}
```

---

## 📱 32-Bit Termux (ARMv7 / `armhf` / `i686`) Fixes & Guide

If you are running Termux on a 32-bit Android device (`armv7l` or `i686`), precompiled 64-bit binaries from Mason or GitHub releases will fail. Follow these solutions:

### 1. Ensure Mason is Disabled
In `lua/plugins/astrolsp.lua`, ensure `mason = false` remains set. This forces AstroLSP to look for system binaries installed via `pkg`, `luarocks`, `cargo`, and `npm`.

### 2. Install Native 32-bit Packages
Always use Termux's native package manager to fetch 32-bit compiled binaries:

```bash
pkg update && pkg upgrade -y
pkg install -y git neovim build-essential clang rust luarocks nodejs-lts python tree-sitter
```

### 3. Enable TUR (Termux User Repository) for Missing Packages
If a specific LSP package is missing in 32-bit main repos, install `tur-repo`:

```bash
pkg install tur-repo
pkg update
```

### 4. Compiling `blink.cmp` or Cargo Crates on 32-Bit
Running `cargo build --release` inside plugin folders automatically detects 32-bit architecture (`armv7-linux-androideabi`) and compiles compatible `.so` dynamic libraries natively on your device.

### 5. Treesitter Parser Compilation
Ensure `clang` and `build-essential` are installed so `nvim-treesitter` can compile 32-bit parser binaries (`.so`) on the fly when opening files for the first time.

---

## 📄 Compiling LaTeX (`.tex`) to PDF in Termux

To compile `.tex` files into `.pdf` documents in Termux and inside Neovim, you have two options:

### Option 1: `tectonic` (Recommended – Modern & Fast)
`tectonic` is a Rust-based TeX engine that automatically downloads missing packages on demand and directly compiles `.tex` into `.pdf`.

```bash
# 1. Install tectonic in Termux:
pkg install tectonic

# 2. Compile a .tex file to PDF:
tectonic document.tex
```

### Option 2: `texlive-bin` (Traditional TeXLive Engine)
Provides `pdflatex`, `xelatex`, `lualatex`, and `latexmk`.

```bash
# 1. Install TeXLive binaries in Termux:
pkg install texlive-bin

# 2. Compile using pdflatex or latexmk:
pdflatex document.tex
# or
latexmk -pdf document.tex
```

### Live PDF Preview in Browser / Viewer (`knap.nvim` + `vimtex`)

This configuration includes `frabjous/knap` and `vimtex` for automatic live PDF previewing and LaTeX editing.

The `<Leader>k` group is **buffer-local** and appears in WhichKey **only when editing LaTeX files** (`.tex`, `.plaintex`):

- `<Leader>k` (`󰈦 LaTeX`):
  - `p` : Toggle Live Auto-Preview ON/OFF (Compiles on save and opens PDF via `xdg-open`)
  - `v` : Refresh / Jump to PDF Viewer
  - `c` : Close PDF Viewer
