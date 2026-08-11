---@type LazySpec
return {
  "frabjous/knap",
  ft = { "tex", "plaintex", "markdown" },
  init = function()
    vim.g.knap_settings = {
      texoutputext = "pdf",
      textopdf = "env LD_PRELOAD= pandoc %docroot% -o %outputfile% --pdf-engine=typst",
      textopdfviewerlaunch = "termux-open %outputfile%",
      textopdfviewerrefresh = "none",
      textopdfshorterror = "none",
      mdoutputext = "pdf",
      mdtopdf = "env LD_PRELOAD= pandoc %docroot% -o %outputfile% --pdf-engine=typst",
      mdtopdfviewerlaunch = "termux-open %outputfile%",
      mdtopdfviewerrefresh = "none",
      markdownoutputext = "pdf",
      markdowntopdf = "env LD_PRELOAD= pandoc %docroot% -o %outputfile% --pdf-engine=typst",
      markdowntopdfviewerlaunch = "termux-open %outputfile%",
      markdowntopdfviewerrefresh = "none",
    }
  end,
  config = function()
    local function setup_keymaps(buf)
      vim.keymap.set("n", "<Leader>kp", function() require("knap").toggle_autopreviewing() end, { buffer = buf, desc = "Toggle Live PDF Preview" })
      vim.keymap.set("n", "<Leader>kv", function() require("knap").forward_jump() end, { buffer = buf, desc = "Jump to PDF Viewer" })
      vim.keymap.set("n", "<Leader>kc", function() require("knap").close_viewer() end, { buffer = buf, desc = "Close PDF Viewer" })

      local wk_ok, wk = pcall(require, "which-key")
      if wk_ok then
        wk.add({
          { "<Leader>k", group = "󰈦 Preview", buffer = buf },
        })
      end
    end

    -- Setup for current buffer when plugin loads
    local ft = vim.bo.filetype
    if ft == "tex" or ft == "plaintex" or ft == "markdown" then
      setup_keymaps(0)
    end

    -- Setup for any newly opened buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "plaintex", "markdown" },
      callback = function(event)
        setup_keymaps(event.buf)
      end,
    })
  end,
}
