---@type LazySpec
return {
  "frabjous/knap",
  ft = { "tex", "plaintex" },
  init = function()
    local kcfg = {
      texoutputext = "pdf",
      textopdf = 'sh -c "if command -v pdflatex >/dev/null 2>&1; then pdflatex -interaction=nonstopmode %docroot%; else curl -s -F \"file=@%docroot%\" https://latex.ytotech.com/builds/sync -o %outputfile%; fi"',
      textopdfviewerlaunch = "xdg-open %outputfile%",
      textopdfviewerrefresh = "none",
      textopdfshorterror = "none",
    }
    vim.g.knap_settings = kcfg

    -- Set keymaps and WhichKey group ONLY on LaTeX buffers (tex / plaintex)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "tex", "plaintex" },
      callback = function(event)
        local buf = event.buf
        vim.keymap.set("n", "<Leader>kp", function() require("knap").toggle_autopreviewing() end, { buffer = buf, desc = "Toggle Live PDF Preview" })
        vim.keymap.set("n", "<Leader>kv", function() require("knap").forward_jump() end, { buffer = buf, desc = "Jump to PDF Viewer" })
        vim.keymap.set("n", "<Leader>kc", function() require("knap").close_viewer() end, { buffer = buf, desc = "Close PDF Viewer" })

        local wk_ok, wk = pcall(require, "which-key")
        if wk_ok then
          wk.add({
            { "<Leader>k", group = "󰈦 LaTeX", buffer = buf },
          })
        end
      end,
    })
  end,
}
