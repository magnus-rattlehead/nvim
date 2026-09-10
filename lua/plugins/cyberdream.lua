require("cyberdream").setup({
  variant = "default",
  transparent = true,
  saturation = 1,
  italic_comments = true,
  hide_fillchars = false,
  borderless_pickers = false,
  terminal_colors = true,
  cache = false,

  overrides = function(colors)
    return {
      NormalFloat = { fg = colors.fg, bg = colors.bg_alt },
      FloatTitle = { fg = colors.cyan, bg = colors.bg_alt },
      FloatFooter = { fg = colors.cyan, bg = colors.bg_alt },
      FloatBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      Pmenu = { fg = colors.fg, bg = colors.bg_alt },
      TelescopeNormal = { fg = colors.fg, bg = colors.bg_alt },
      TelescopePromptNormal = { fg = colors.fg, bg = colors.bg_alt },
      TelescopeResultsNormal = { fg = colors.fg, bg = colors.bg_alt },
      TelescopePreviewNormal = { fg = colors.fg, bg = colors.bg_alt },
      TelescopeBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      TelescopePromptBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      TelescopeResultsBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      TelescopePreviewBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      WhichKeyNormal = { fg = colors.fg, bg = colors.bg_alt },
      LazyNormal = { fg = colors.fg, bg = colors.bg_alt },
      MasonNormal = { fg = colors.fg, bg = colors.bg_alt },
      NvimTreeNormalFloat = { fg = colors.fg, bg = colors.bg_alt },
      NvimTreeNormalFloatBorder = { fg = colors.bg_highlight, bg = colors.bg_alt },
      CmpDocumentation = { fg = colors.grey, bg = colors.bg_alt },
      CmpDocumentationBorder = { fg = colors.grey, bg = colors.bg_alt },
    }
  end,


  extensions = {
    default = true,
  },

})
vim.cmd("colorscheme cyberdream")
