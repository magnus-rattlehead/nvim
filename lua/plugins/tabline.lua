local tabline = require("mini.tabline")

local function get_colors()
  local ok, cyberdream = pcall(require, "cyberdream.colors")
  if ok then
    return cyberdream.default
  end

  return {
    bg = "NONE",
    fg = "#ffffff",
    grey = "#7b8496",
    cyan = "#5ef1ff",
    magenta = "#ff5ef1",
  }
end

local function set_highlights()
  local colors = get_colors()
  local bg = "NONE"

  local groups = {
    TabLine = { fg = colors.grey, bg = bg },
    TabLineSel = { fg = colors.fg, bg = bg, bold = true },
    TabLineFill = { bg = bg },

    MiniTablineCurrent = { fg = colors.fg, bg = bg, bold = true },
    MiniTablineVisible = { fg = colors.fg, bg = bg },
    MiniTablineHidden = { fg = colors.grey, bg = bg },
    MiniTablineModifiedCurrent = { fg = colors.magenta, bg = bg, bold = true },
    MiniTablineModifiedVisible = { fg = colors.magenta, bg = bg },
    MiniTablineModifiedHidden = { fg = colors.grey, bg = bg },
    MiniTablineFill = { bg = bg },
    MiniTablineTabpagesection = { fg = colors.cyan, bg = bg, bold = true },
    MiniTablineTrunc = { fg = colors.grey, bg = bg },
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

tabline.setup({
  show_single_tab = true,
  set_vim_settings = true,
})

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("user_tabline_highlights", { clear = true }),
  callback = set_highlights,
})
