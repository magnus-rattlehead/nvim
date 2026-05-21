-- Powerline symbols via UTF-8 byte sequences (U+E0B0..E0B3)
local sep  = string.char(0xEE, 0x82, 0xB0)  -- U+E0B0 filled right arrow
local sep2 = string.char(0xEE, 0x82, 0xB2)  -- U+E0B2 filled left arrow
local sub  = string.char(0xEE, 0x82, 0xB1)  -- U+E0B1 thin right arrow
local sub2 = string.char(0xEE, 0x82, 0xB3)  -- U+E0B3 thin left arrow

local function tagbar_tag()
  if vim.fn.exists(":TagbarCurrentTag") ~= 0 then
    return vim.fn["tagbar#currenttag"]("%s", "", "f")
  end
  return ""
end

require("lualine").setup({
  options = {
    theme = "gruvbox",
    icons_enabled = true,
    section_separators   = { left = sep,  right = sep2 },
    component_separators = { left = sub,  right = sub2 },
    disabled_filetypes = { statusline = { "NvimTree" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename", tagbar_tag },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {
    lualine_a = { "tabs" },
    lualine_z = { "buffers" },
  },
})
