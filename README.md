# AstroNvim Termux Setup 🚀

A pre-configured, mobile-optimized [AstroNvim](https://github.com/AstroNvim/AstroNvim) **v6+** configuration tailored specifically for **Termux (Android)** and **Linux** environments.

This setup uses native binary detection to bypass Mason glibc compatibility issues on Android, providing high-performance LSP servers, Treesitter parsers, None-LS formatters, and Live PDF Preview for LaTeX and Markdown files.

---

## 📋 Table of Contents

- [Supported Languages & Tools](#-supported-languages--tools)
- [System Requirements](#-system-requirements)
- [Step-by-Step Installation Guide](#-step-by-step-installation-guide)
  - [Step 1: Install Termux System Packages](#step-1-install-termux-system-packages)
  - [Step 2: Install Global npm & LuaRocks Packages](#step-2-install-global-npm--luarocks-packages)
  - [Step 3: Optional Android NDK Native Stubs](#step-3-optional-android-ndk-native-stubs)
  - [Step 4: Update Shell PATH](#step-4-update-shell-path)
  - [Step 5: Backup Existing Neovim Configuration](#step-5-backup-existing-neovim-configuration)
  - [Step 6: Clone Repository](#step-6-clone-repository)
  - [Step 7: Launch Neovim](#step-7-launch-neovim)
- [📄 LaTeX & Markdown Live PDF Preview](#-latex--markdown-live-pdf-preview)
  - [Preview Features](#preview-features)
  - [WhichKey Keymaps (Buffer-Local)](#whichkey-keymaps-buffer-local)
  - [Termux LD_PRELOAD Environment Fix](#termux-ld_preload-environment-fix)
- [🤖 Smali (Android Bytecode) LSP Environment](#-smali-android-bytecode-lsp-environment)
- [⚡ Building blink.cmp Natively](#-building-blinkcmp-natively-libblink_cmp_fuzzyso)
- [📱 32-Bit Termux (ARMv7 / i686) Guide](#-32-bit-termux-armv7--i686-guide)
- [🔍 Verification & Diagnostics](#-verification--diagnostics)

---

## 🛠 Supported Languages & Tools

| Language / Filetype | Language Server (LSP) | Formatter / Linter | Binary Source |
| :--- | :--- | :--- | :--- |
| **Lua** | `lua_ls` | `stylua` | Termux `pkg` |
| **Bash / Shell** | `bashls` | `shfmt` | `npm` / Termux `pkg` |
| **C / C++ / ObjC** | `clangd` / `ccls` | `clang-format` | Termux `pkg` |
| **Rust** | `rust_analyzer` | `cargo fmt` | Termux `pkg` / Cargo |
| **LaTeX / TeX** | `texlab` / `digestif` | LSP / `latexindent` | Termux `pkg` / LuaRocks |
| **Markdown / Web** | `render-markdown` | `prettier` | Termux `pkg` / `npm` / Lazy Spec |
| **JSON / JQ** | `jq_lsp` | `prettier` | Termux `pkg` / `npm` |
| **Fish Shell** | `fish_lsp` | `fish_indent` | `npm` / Termux `pkg` |
| **Smali (Android Bytecode)** | `smali_lsp` | LSP Diagnostics | Built fat JAR (`smali-lsp-1.5.0.jar`) |

---

## ⚙️ System Requirements

- **Termux** on Android (ARM64 `aarch64` or 32-bit `armv7l`).
- **Neovim 0.10+** (AstroNvim v6+ compatible).
- C/C++ build toolchain (`clang`, `build-essential`, `make`).
- Rust toolchain (`cargo`, `rustc`).
- `typst` & `pandoc` for PDF compilation and live preview.

---

## 📥 Step-by-Step Installation Guide

### Step 1: Install Termux System Packages

Run the following command in Termux to install Neovim, compilers, development tools, PDF generators, and native LSP packages:

```bash
apt update && yes | apt upgrade
apt install -y \
  git \
  neovim \
  build-essential \
  clang \
  ccls \
  ripgrep \
  fzf \
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
  tectonic \
  typst \
  pandoc
```

> **Note on `fish_indent` & Fish Shell:**  
> `fish_indent` comes pre-packaged with `fish`. Installing `pkg install fish` automatically places `fish_indent` at `/data/data/com.termux/files/usr/bin/fish_indent`. `none-ls` automatically detects it for formatting `.fish` files.

### Step 2: Install Global npm & LuaRocks Packages

Install Node.js based LSPs/formatters, `fish-lsp`, and the Lua-based TeX LSP (`digestif`):

```bash
# Install bash language server, prettier, and fish-lsp globally via npm
npm install -g bash-language-server prettier @fish-lsp/fish-lsp

# Install digestif (LaTeX LSP) via LuaRocks
luarocks install digestif
```

### Step 3: Optional Android NDK Native Stubs

If you are compiling C/C++ or Rust libraries that link directly against Android NDK native shared libraries (like `liblog`, `libandroid`, `libvulkan`), install NDK native stubs:

```bash
pkg install ndk-multilib ndk-multilib-native-stubs
```

### Step 4: Update Shell PATH

Ensure your shell (`~/.bashrc`, `~/.zshrc`, or `config.fish`) includes `~/.cargo/bin` and `~/.local/bin` in your environment `PATH`.

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

### Step 6: Clone Repository

Clone this repository into `~/.config/nvim`:

```bash
git clone https://github.com/remo7777/Astronvim-Termux ~/.config/nvim
```

### Step 7: Launch Neovim

Start Neovim for the first time. Plugins will automatically download and sync via `lazy.nvim`:

```bash
nvim
```

---

## 📄 LaTeX & Markdown Live PDF Preview

This setup includes a complete document editing suite with **TeXLab LSP**, **VimTeX**, and **Knap Live PDF Preview** supporting both **LaTeX (`.tex`)** and **Markdown (`.md`)** files.

### Preview Features
1. **Typst Engine**: Uses `typst` as the PDF rendering engine for ultra-fast, high-quality compilation with full UTF-8 Unicode and Emoji support (`📘`, `💡`, `🏋️`).
2. **TeXLab LSP Tuning**: Suppresses harmless `"Unused label"` diagnostic hints while retaining error diagnostics.
3. **VimTeX Integration**: AstroCommunity VimTeX integration (`astrocommunity.markdown-and-latex.vimtex`) for LaTeX syntax highlighting, TOC navigation (`:VimtexTocOpen`), and environment motions.
4. **Android Native Viewer**: Uses `termux-open` to automatically open and refresh generated PDF files in your default Android PDF Viewer / Reader.

### WhichKey Keymaps (Buffer-Local)

The `<Leader>k` group is **buffer-local** and appears in WhichKey when editing LaTeX (`.tex`, `.plaintex`) or Markdown (`.md`) files. On other files (`.sh`, `.lua`, `.py`, `.c`), `<Leader>k` remains hidden.

When editing a `.tex` or `.md` file, press `<Space>` (Leader key) to see:

```text
k - 󰈦 Preview
├── p - Toggle Live PDF Preview
├── v - Jump to PDF Viewer
└── c - Close PDF Viewer
```

- `<Leader>kp` : Toggle Live Auto-Preview ON/OFF (Compiles on save and opens PDF via `termux-open`)
- `<Leader>kv` : Refresh / Jump to PDF Viewer
- `<Leader>kc` : Close PDF Viewer

### Termux `LD_PRELOAD` Environment Fix

In Termux, Neovim exports `LD_PRELOAD=/data/data/com.termux/files/usr/lib/libluajit.so`. When Pandoc (which uses standard Lua 5.4) is spawned from inside Neovim (`jobstart`), force-preloaded LuaJIT symbols cause dynamic symbol conflicts resulting in `PANIC: unprotected error in call to Lua API` (exit code 1).

This configuration automatically prepends `env LD_PRELOAD=` to all Knap execution routines ([knap.lua](file:///data/data/com.termux/files/home/.config/nvim/lua/plugins/knap.lua)), ensuring clean, error-free PDF background rendering:

```lua
textopdf = "env LD_PRELOAD= pandoc %docroot% -o %outputfile% --pdf-engine=typst",
mdtopdf = "env LD_PRELOAD= pandoc %docroot% -o %outputfile% --pdf-engine=typst",
```

---

## 🤖 Smali (Android Bytecode) LSP Environment

This setup includes a native **Smali Language Server (`smali_lsp`)** and **Tree-sitter Smali** environment for Android bytecode reverse engineering.

### Smali Features
1. **Smali LSP (`smali_lsp`)**: Real-time syntax and semantic diagnostics (`textDocument/publishDiagnostics`), class/method document symbols, declaration lookups, and autocompletion.
2. **Global Binary Launcher**: Executable launcher at `~/.local/bin/smali-lsp` running the high-performance Kotlin/ANTLR shadow JAR (`smali-lsp-1.5.0.jar`).
3. **Automatic Workspace Detection**: Automatically attaches to project roots containing `.git`, `AndroidManifest.xml`, or `apktool.yml`, with single-file fallback.
4. **Tree-sitter Smali**: Fast syntax highlighting and AST node parsing via `nvim-treesitter`.

---

## ⚡ Building `blink.cmp` Natively (`libblink_cmp_fuzzy.so`)

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

## 📱 32-Bit Termux (ARMv7 / `armhf` / `i686`) Guide

If you are running Termux on a 32-bit Android device (`armv7l` or `i686`), precompiled 64-bit binaries from Mason or GitHub releases will fail. Follow these solutions:

### 1. Ensure Mason is Disabled
In `lua/plugins/astrolsp.lua`, ensure `mason = false` remains set. This forces AstroLSP to look for system binaries installed via `pkg`, `luarocks`, `cargo`, and `npm`.

### 2. Install Native 32-bit Packages
Always use Termux's native package manager to fetch 32-bit compiled binaries:

```bash
pkg update && pkg upgrade -y
pkg install -y git neovim build-essential clang rust luarocks nodejs-lts python tree-sitter typst pandoc
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

## 🔍 Verification & Diagnostics

Inside Neovim, verify that all plugins and LSPs are installed properly:

```vim
:checkhealth
:LspInfo
```

To test loaded AstroLSP server status from the command line:

```bash
nvim --headless +":lua print(vim.inspect(require('astrolsp').config.servers))" +q
```
