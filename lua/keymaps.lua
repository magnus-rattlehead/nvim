local map = vim.keymap.set

-- Fast saving / closing
map("n", "<leader>w", ":w!<cr>")
map("n", "<leader>q", ":q<cr>")
map("n", "<leader>Q", ":q!<cr>")

-- Clear search highlight
map("n", "<Esc><Esc>", ":noh<cr>", { silent = true })

-- Exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>")

-- Buffer management
map("", "<leader>bd", ":bd<cr>")
map("", "<leader>ba", ":bufdo bd<cr>")
map("n", "<C-N>", ":bnext<cr>")
map("n", "<C-M>", ":bprev<cr>")

-- Tab management
map("", "<leader>tn", ":tabnew<cr>")
map("", "<leader>to", ":tabonly<cr>")
map("", "<leader>tc", ":tabclose<cr>")
map("", "<leader>tm", ":tabmove")
map("", "<C-w>", ":tabnext<cr>")
map("", "<C-q>", ":tabprev<cr>")
map("n", "<leader>tl", function()
  vim.cmd("tabn " .. vim.g.lasttab)
end)

-- Split navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Remap 0 to first non-blank character
map("", "0", "^")

-- Move lines with Alt+j/k
map("n", "<M-j>", "mz:m+<cr>`z")
map("n", "<M-k>", "mz:m-2<cr>`z")
map("v", "<M-j>", ":m'>+<cr>`<my`>mzgv`yo`z")
map("v", "<M-k>", ":m'<-2<cr>`>my`<mzgv`yo`z")

-- jk as ESC
map("i", "jk", "<ESC>")
map("v", "jk", "<ESC>")
map("i", "kj", "<ESC>")
map("v", "kj", "<ESC>")

-- Spell checking toggle
map("", "<leader>ss", ":setlocal spell!<cr>")

-- Sudo save
vim.api.nvim_create_user_command("W", function()
  vim.cmd("w !sudo tee % > /dev/null")
  vim.cmd("edit!")
end, {})
