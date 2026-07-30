---@type LazySpec
return {
  "lervag/vimtex",
  init = function()
    -- Disable VimTeX compiler checks so it doesn't warn about missing latexmk
    -- (compilation is handled seamlessly by knap.nvim)
    vim.g.vimtex_compiler_enabled = 0
  end,
}
