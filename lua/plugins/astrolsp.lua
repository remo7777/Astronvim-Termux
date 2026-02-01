-- Helper function to check if a binary exists before adding it to the LSP list
local servers = {}
local function add_server_if_exists(name, path)
  if vim.fn.executable(path) == 1 then table.insert(servers, name) end
end

-- Validate and add servers based on your Termux paths
add_server_if_exists("lua_ls", "/data/data/com.termux/files/usr/bin/lua-language-server")
add_server_if_exists("clangd", "/data/data/com.termux/files/usr/bin/clangd")
add_server_if_exists("ccls", "/data/data/com.termux/files/usr/bin/ccls")
add_server_if_exists("jq_lsp", "/data/data/com.termux/files/usr/bin/jq-lsp")
add_server_if_exists("rust_analyzer", "/data/data/com.termux/files/usr/bin/rust-analyzer")
add_server_if_exists("texlab", "/data/data/com.termux/files/usr/bin/texlab")
add_server_if_exists("fish_lsp", "/data/data/com.termux/files/home/fish-lsp/bin/fish-lsp")

return {
  "AstroNvim/astrolsp",
  opts = {
    -- Disable Mason automatic management since we are using manual Termux paths
    meson = false,
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        -- Auto-format will only trigger for these specific filetypes
        allow_filetypes = { "c", "cpp", "objc", "objcpp", "json", "jq", "rust", "tex" },
      },
      timeout_ms = 1000,
    },
    -- Use the dynamically generated list of available servers
    servers = servers,

    config = {
      fish_lsp = {
        cmd = { "/data/data/com.termux/files/home/fish-lsp/bin/fish-lsp", "start" },
        filetypes = { "fish" },
        root_dir = require("lspconfig").util.root_pattern(".git", vim.fn.getcwd()),
      },
      clangd = {
        capabilities = { offsetEncoding = { "utf-16" } },
        cmd = { "/data/data/com.termux/files/usr/bin/clangd" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        settings = { clangd = { format = { style = "file" } } },
      },
      ccls = {
        capabilities = { offsetEncoding = { "utf-16" } },
        cmd = { "/data/data/com.termux/files/usr/bin/ccls" },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        settings = { ccls = { cache = { directory = ".ccls-cache" } } },
      },
      jq_lsp = {
        cmd = { "/data/data/com.termux/files/usr/bin/jq-lsp" },
        filetypes = { "json", "jq" },
        root_dir = require("lspconfig").util.root_pattern(".git", vim.fn.getcwd()),
      },
      rust_analyzer = {
        cmd = { "/data/data/com.termux/files/usr/bin/rust-analyzer" },
        filetypes = { "rust" },
        root_dir = require("lspconfig").util.root_pattern("Cargo.toml", ".git", vim.fn.getcwd()),
        settings = {
          ["rust-analyzer"] = {
            assist = { importMergeBehavior = "last", importPrefix = "by_self" },
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
      texlab = {
        cmd = { "/data/data/com.termux/files/usr/bin/texlab" },
        filetypes = { "tex", "bib" },
        root_dir = require("lspconfig").util.root_pattern(".git", vim.fn.getcwd()),
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "-shell-escape", "%f" },
              onSave = true,
            },
            forwardSearch = {
              executable = "zathura", -- Ensure Zathura is installed in Termux if used
              args = { "--synctex-forward", "%l:1:%f", "%p" },
            },
            chktex = { onEdit = true, onOpenAndSave = true },
          },
        },
      },
    },
    handlers = {
      -- Default handler for setting up servers
      function(server, opts) require("lspconfig")[server].setup(opts) end,
    },
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = { function() vim.lsp.buf.declaration() end, desc = "Declaration of current symbol" },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Add any custom on_attach logic here
    end,
  },
}
