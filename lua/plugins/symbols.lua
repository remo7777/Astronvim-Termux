return {
  {
    "stevearc/aerial.nvim",
    opts = function(_, opts)
      if not opts.filter_kind then
        opts.filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
        }
      end
      local additional_kinds = { "Variable", "Constant", "Field", "Property" }
      for _, kind in ipairs(additional_kinds) do
        if not vim.list_contains(opts.filter_kind, kind) then
          table.insert(opts.filter_kind, kind)
        end
      end
      return opts
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      return require("astrocore").extend_tbl(opts, {
        picker = {
          sources = {
            lsp_symbols = {
              filter = {
                default = {
                  "Class",
                  "Constructor",
                  "Enum",
                  "Field",
                  "Function",
                  "Interface",
                  "Method",
                  "Module",
                  "Namespace",
                  "Package",
                  "Property",
                  "Struct",
                  "Trait",
                  "Variable",
                  "Constant",
                },
              },
            },
          },
        },
      })
    end,
  },
}
