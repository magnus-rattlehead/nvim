vim.g.mapleader = " "

-- disable netrw for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("autocmds")
require("plugins")
require("keymaps")
