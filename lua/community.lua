-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  -- { import = "astrocommunity.completion.cmp-cmdline" },
  { import = "astrocommunity.recipes.cache-colorscheme" },
  { import = "astrocommunity.completion.cmp-nerdfont" },
  -- { import = "astrocommunity.completion.avante-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.comment.ts-comments-nvim" },
  -- { import = "astrocommunity.recipes.astrolsp-auto-signature-help" },
  { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },
  { import = "astrocommunity.utility.noice-nvim" },
  -- import/override with your plugins folder
}
