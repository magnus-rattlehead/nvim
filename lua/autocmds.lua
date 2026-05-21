local autocmd = vim.api.nvim_create_autocmd

-- matchit (built-in in neovim but loaded explicitly for compatibility)
vim.cmd("runtime macros/matchit.vim")

-- Auto-read files changed outside vim
autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "silent! checktime",
})

-- Track last tab for <leader>tl
vim.g.lasttab = 1
autocmd("TabLeave", {
  pattern = "*",
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end,
})

-- Return to last edit position when opening a file
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local line = vim.fn.line("'\"")
    if line > 1 and line <= vim.fn.line("$") then
      vim.cmd("normal! g'\"")
    end
  end,
})

-- Delete trailing whitespace on save for common filetypes
local function clean_extra_spaces()
  local save_cursor = vim.fn.getpos(".")
  local old_query = vim.fn.getreg("/")
  vim.cmd([[silent! %s/\s\+$//e]])
  vim.fn.setpos(".", save_cursor)
  vim.fn.setreg("/", old_query)
end

autocmd("BufWritePre", {
  pattern = { "*.txt", "*.js", "*.py", "*.wiki", "*.sh", "*.coffee" },
  callback = clean_extra_spaces,
})
