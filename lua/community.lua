---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.colorscheme.rose-pine" },
  { import = "astrocommunity.recipes.cache-colorscheme" },
  { import = "astrocommunity.completion.cmp-nerdfont" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.fuzzy-finder.snacks-picker" },
  -- import/override with your plugins folder
}
