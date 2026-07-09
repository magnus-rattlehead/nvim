local statusline = require("mini.statusline")

local function get_colors()
  local ok, cyberdream = pcall(require, "cyberdream.colors")
  if ok then
    return cyberdream.default
  end

  return {
    bg = "NONE",
    fg = "#ffffff",
    grey = "#7b8496",
    green = "#5eff6c",
    cyan = "#5ef1ff",
    red = "#ff6e5e",
    yellow = "#f1ff5e",
    magenta = "#ff5ef1",
    orange = "#ffbd5e",
    purple = "#bd5eff",
  }
end

local function set_highlights()
  local colors = get_colors()
  local bg = "NONE"

  local groups = {
    StatusLine = { fg = colors.fg, bg = bg },
    StatusLineNC = { fg = colors.grey, bg = bg },

    MiniStatuslineModeNormal = { fg = colors.green, bg = bg, bold = true },
    MiniStatuslineModeInsert = { fg = colors.cyan, bg = bg, bold = true },
    MiniStatuslineModeVisual = { fg = colors.magenta, bg = bg, bold = true },
    MiniStatuslineModeReplace = { fg = colors.red, bg = bg, bold = true },
    MiniStatuslineModeCommand = { fg = colors.yellow, bg = bg, bold = true },
    MiniStatuslineModeOther = { fg = colors.orange, bg = bg, bold = true },

    MiniStatuslineDiagnostics = { fg = colors.orange, bg = bg },
    MiniStatuslineBranch = { fg = colors.cyan, bg = bg },
    MiniStatuslineDevinfo = { fg = colors.magenta, bg = bg },
    MiniStatuslineFilename = { fg = colors.fg, bg = bg },
    MiniStatuslineFileinfo = { fg = colors.grey, bg = bg },
    MiniStatuslineProgress = { fg = colors.magenta, bg = bg, bold = true },
    MiniStatuslineLocation = { fg = colors.cyan, bg = bg, bold = true },
    MiniStatuslineInactive = { fg = colors.grey, bg = bg },
  }

  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

local function is_truncated(width)
  return statusline.is_truncated(width)
end

local function get_encoding(width)
  if is_truncated(width) then
    return ""
  end

  return vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
end

local function get_fileformat(width)
  if is_truncated(width) then
    return ""
  end

  return vim.bo.fileformat
end

local function get_filetype(width)
  local filetype = vim.bo.filetype
  if filetype == "" or is_truncated(width) then
    return ""
  end

  return filetype
end

local function get_file_icon()
  if _G.MiniIcons ~= nil then
    local filetype = vim.bo.filetype
    if filetype ~= "" then
      return MiniIcons.get("filetype", filetype)
    end

    local filename = vim.fn.expand("%:p")
    if filename ~= "" then
      return MiniIcons.get("file", filename)
    end
  end

  return ""
end

local function get_filename()
  local icon = get_file_icon()
  local filename

  if vim.fn.expand("%:t") == "" then
    filename = "[No Name]%m%r"
  else
    filename = "%t%m%r"
  end

  return icon ~= "" and icon .. " " .. filename or filename
end

local function get_lsp_icon(kind, fallback)
  if _G.MiniIcons == nil then
    return fallback
  end

  local icon, _, is_default = MiniIcons.get("lsp", kind)
  return not is_default and icon or fallback
end

local function get_diagnostic_signs()
  return {
    ERROR = get_lsp_icon("event", "!") .. " Error ",
    WARN = get_lsp_icon("constant", "?") .. " Warn ",
    INFO = get_lsp_icon("text", "i") .. " Info ",
    HINT = get_lsp_icon("snippet", "*") .. " Hint ",
  }
end

local function get_mode()
  local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
  return mode:upper(), mode_hl
end

local function active()
  local mode, mode_hl = get_mode()
  local branch = statusline.section_git({ trunc_width = 80, icon = "" })
  local diff = statusline.section_diff({ trunc_width = 90 })
  local diagnostics = statusline.section_diagnostics({ icon = "", signs = get_diagnostic_signs() })
  local filename = get_filename()
  local encoding = get_encoding(120)
  local fileformat = get_fileformat(120)
  local filetype = get_filetype(120)
  local progress = is_truncated(60) and "" or "%P"
  local location = is_truncated(60) and "" or "%l:%c"

  return statusline.combine_groups({
    { hl = "MiniStatuslineDiagnostics", strings = { diagnostics } },
    { hl = mode_hl,                     strings = { mode } },
    { hl = "MiniStatuslineBranch",      strings = { branch } },
    "%<",
    { hl = "MiniStatuslineFilename", strings = { filename } },
    { hl = "MiniStatuslineDevinfo",  strings = { diff } },
    "%=",
    { hl = "MiniStatuslineFileinfo", strings = { encoding, fileformat, filetype } },
    { hl = "MiniStatuslineProgress", strings = { progress } },
    { hl = "MiniStatuslineLocation", strings = { location } },
  })
end

local function inactive()
  return statusline.combine_groups({
    { hl = "MiniStatuslineInactive", strings = { get_filename() } },
  })
end

statusline.setup({
  use_icons = true,

  content = {
    active = active,
    inactive = inactive,
  },
})

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("user_statusline_highlights", { clear = true }),
  callback = set_highlights,
})
