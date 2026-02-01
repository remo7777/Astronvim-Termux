-- Customize None-ls sources with executable checks for Termux environment
---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require "null-ls"
    local astrocore = require "astrocore"

    -- Initialize an empty table for our validated sources
    local sources = {}

    -- Helper function to only add sources if the external binary is executable
    local function add_source_if_exists(source, binary)
      if vim.fn.executable(binary) == 1 then
        table.insert(sources, source)
      end
    end

    -- 1. C/C++ Formatting (Requires 'clang-format' package)
    add_source_if_exists(
      null_ls.builtins.formatting.clang_format.with {
        filetypes = { "c", "cpp", "objc", "objcpp" },
        extra_args = { "--style=file" },
      },
      "clang-format"
    )

    -- 2. Fish Shell Support (Requires 'fish' package)
    add_source_if_exists(null_ls.builtins.formatting.fish_indent, "fish")
    add_source_if_exists(null_ls.builtins.diagnostics.fish, "fish")

    -- 3. Lua Formatting (Requires 'stylua' package)
    add_source_if_exists(null_ls.builtins.formatting.stylua, "stylua")

    -- 4. Prettier for JSON/Markdown/Web (Requires 'prettier' via npm/pkg)
    add_source_if_exists(null_ls.builtins.formatting.prettier, "prettier")

    -- 5. Shell Script Formatting (Requires 'shfmt' package)
    add_source_if_exists(
      null_ls.builtins.formatting.shfmt.with {
        extra_args = { "-i", "2", "-ci" },
      },
      "shfmt"
    )

    -- Merge our validated sources into the existing AstroNvim opts table
    opts.sources = astrocore.list_insert_unique(opts.sources, sources)
  end,
}
