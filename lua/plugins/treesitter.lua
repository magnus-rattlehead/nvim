-- nvim-treesitter v1.0: parsers installed via :TSInstall / :TSUpdate
-- highlight and indent delegate to neovim's built-in vim.treesitter
require("nvim-treesitter").setup()

vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
