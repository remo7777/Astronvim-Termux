---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts = function()
    -- Helper: detect installed binaries (checks absolute path or PATH)
    local servers = {}
    local function add(name, path)
      if (path and vim.fn.executable(path) == 1) or vim.fn.executable(name) == 1 then
        if not vim.tbl_contains(servers, name) then
          table.insert(servers, name)
        end
      end
    end

    vim.filetype.add { extension = { smali = "smali" } }

    -- Register custom smali_lsp in lspconfig if not already registered
    local configs = require "lspconfig.configs"
    if not configs.smali_lsp then
      configs.smali_lsp = {
        default_config = {
          cmd = { "/data/data/com.termux/files/home/.local/bin/smali-lsp" },
          filetypes = { "smali" },
          root_dir = function(fname)
            local util = require "lspconfig.util"
            local path = type(fname) == "string" and fname or vim.api.nvim_buf_get_name(fname)
            return util.root_pattern(".git", "AndroidManifest.xml", "apktool.yml")(path) or util.find_git_ancestor(path) or vim.fs.dirname(path)
          end,
          name = "smali_lsp",
        },
      }
    end

    -- Detect Termux-installed LSPs
    add("lua_ls", "/data/data/com.termux/files/usr/bin/lua-language-server")
    add("bashls", "/data/data/com.termux/files/usr/bin/bash-language-server")
    add("clangd", "/data/data/com.termux/files/usr/bin/clangd")
    add("ccls", "/data/data/com.termux/files/usr/bin/ccls")
    add("jq_lsp", "/data/data/com.termux/files/usr/bin/jq-lsp")
    add("rust_analyzer", "/data/data/com.termux/files/usr/bin/rust-analyzer")
    add("fish_lsp", "/data/data/com.termux/files/usr/bin/fish-lsp")
    add("fish_lsp", "/data/data/com.termux/files/home/fish-lsp/bin/fish-lsp")
    add("texlab", "/data/data/com.termux/files/usr/bin/texlab")
    add("texlab", "/data/data/com.termux/files/home/.cargo/bin/texlab")
    add("digestif", "/data/data/com.termux/files/usr/bin/digestif")
    add("smali_lsp", "/data/data/com.termux/files/home/.local/bin/smali-lsp")

    return {
      mason = false,

      features = {
        codelens = true,
        inlay_hints = false,
        semantic_tokens = true,
      },

      formatting = {
        format_on_save = {
          enabled = true,
          allow_filetypes = {
            "c",
            "cpp",
            "objc",
            "objcpp",
            "json",
            "jq",
            "rust",
            "tex",
            "plaintex",
          },
        },
        timeout_ms = 3000,
      },

      servers = servers,

      config = {
        bashls = {
          cmd = { "/data/data/com.termux/files/usr/bin/bash-language-server", "start" },
        },

        fish_lsp = {
          cmd = vim.fn.executable("/data/data/com.termux/files/usr/bin/fish-lsp") == 1
            and { "/data/data/com.termux/files/usr/bin/fish-lsp", "start" }
            or (vim.fn.executable("/data/data/com.termux/files/home/fish-lsp/bin/fish-lsp") == 1
              and { "/data/data/com.termux/files/home/fish-lsp/bin/fish-lsp", "start" }
              or { "fish-lsp", "start" }),
          filetypes = { "fish" },
        },

        clangd = {
          cmd = { "/data/data/com.termux/files/usr/bin/clangd" },
          filetypes = { "c", "cpp", "objc", "objcpp" },
          capabilities = { offsetEncoding = { "utf-16" } },
        },

        jq_lsp = {
          cmd = { "/data/data/com.termux/files/usr/bin/jq-lsp" },
          filetypes = { "json", "jq" },
        },

        rust_analyzer = {
          cmd = vim.fn.executable("/data/data/com.termux/files/usr/bin/rust-analyzer") == 1
            and { "/data/data/com.termux/files/usr/bin/rust-analyzer" }
            or { "rust-analyzer" },
          filetypes = { "rust" },
          settings = {
            ["rust-analyzer"] = {
              cargo = { loadOutDirsFromCheck = true },
              procMacro = { enable = true },
            },
          },
        },

        lua_ls = {
          cmd = { "/data/data/com.termux/files/usr/bin/lua-language-server" },
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },

        digestif = {
          cmd = vim.fn.executable("/data/data/com.termux/files/usr/bin/digestif") == 1
            and { "/data/data/com.termux/files/usr/bin/digestif" }
            or { "digestif" },
          filetypes = { "tex", "bib", "plaintex" },
        },

        texlab = {
          cmd = vim.fn.executable("/data/data/com.termux/files/usr/bin/texlab") == 1
            and { "/data/data/com.termux/files/usr/bin/texlab" }
            or (vim.fn.executable("/data/data/com.termux/files/home/.cargo/bin/texlab") == 1
              and { "/data/data/com.termux/files/home/.cargo/bin/texlab" }
              or { "texlab" }),
          filetypes = { "tex", "plaintex", "bib" },
          settings = {
            texlab = {
              diagnostics = {
                ignoredPatterns = { "Unused label" },
              },
            },
          },
        },

        smali_lsp = {
          cmd = { "/data/data/com.termux/files/home/.local/bin/smali-lsp" },
          filetypes = { "smali" },
          root_dir = function(fname)
            local util = require "lspconfig.util"
            local path = type(fname) == "string" and fname or vim.api.nvim_buf_get_name(fname)
            return util.root_pattern(".git", "AndroidManifest.xml", "apktool.yml")(path) or util.find_git_ancestor(path) or vim.fs.dirname(path)
          end,
        },
      },

      handlers = {
        smali_lsp = function(server, opts)
          local server_opts = vim.tbl_deep_extend("force", {
            cmd = { "/data/data/com.termux/files/home/.local/bin/smali-lsp" },
            filetypes = { "smali" },
            root_dir = function(fname)
              local util = require "lspconfig.util"
              local path = type(fname) == "string" and fname or vim.api.nvim_buf_get_name(fname)
              return util.root_pattern(".git", "AndroidManifest.xml", "apktool.yml")(path) or util.find_git_ancestor(path) or vim.fs.dirname(path)
            end,
          }, opts or {})

          local configs = require "lspconfig.configs"
          if not configs.smali_lsp then
            configs.smali_lsp = {
              default_config = server_opts,
            }
          end
          require("lspconfig").smali_lsp.setup(server_opts)
        end,
        function(server, opts) require("lspconfig")[server].setup(opts) end,
      },

      mappings = {
        n = {
          gD = { function() vim.lsp.buf.declaration() end, desc = "Declaration" },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle semantic highlight",
          },
          ["<Leader>lf"] = {
            function()
              local conform_ok, conform = pcall(require, "conform")
              if conform_ok then
                conform.format { lsp_fallback = true, timeout_ms = 3000 }
              else
                vim.lsp.buf.format { async = true, timeout_ms = 3000 }
              end
            end,
            desc = "Format buffer",
          },
        },
      },

      autocmds = {
        lsp_codelens_refresh = {
          cond = "textDocument/codeLens",
          {
            event = { "InsertLeave", "BufEnter" },
            callback = function(args)
              if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
            end,
          },
        },
      },
    }
  end,
}
