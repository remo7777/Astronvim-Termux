return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = function(_, opts)
    local utils = require "astrocore"
    -- calculate dynamic width based on current terminal size
    local dynamic_min_width = math.max(20, vim.o.columns - 6)  -- 20 = safe lower bound

    return utils.extend_tbl(opts, {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = utils.is_available "inc-rename.nvim",
        lsp_doc_border = false,
      },
      views = {
        cmdline_popup = {
          position = {
            row = "50%",
            col = "50%",
          },
          size = {
            width  = "auto",
            height = "auto",
            min_width = dynamic_min_width,  -- ✅ dynamic value
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "FloatBorder",
            },
          },
        },
        hover = {
          size = { min_width = dynamic_min_width },
        },
        signature = {
          size = { min_width = dynamic_min_width },
        },
        notify = {
          win_options = {
            winhighlight = {
              Normal = "Normal",
              FloatBorder = "FloatBorder",
            },
          },
        },
      },
    })
  end,
  specs = {
    -- specs section same as before…
  },
}
