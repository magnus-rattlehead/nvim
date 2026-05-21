vim.g.Lf_HideHelp = 1
vim.g.Lf_UseCache = 0
vim.g.Lf_UseVersionControlTool = 0
vim.g.Lf_IgnoreCurrentBufferName = 1
vim.g.Lf_WindowPosition = "popup"
vim.g.Lf_StlSeparator = {
  left = "",
  right = "",
  font = "DejaVu Sans Mono for Powerline",
}
vim.g.Lf_PreviewResult = { Function = 0, BufTag = 0 }
vim.g.Lf_ShortcutF = "<leader>ff"
vim.g.Lf_GtagsAutoGenerate = 0
vim.g.Lf_Gtagslabel = "native-pygments"

local map = vim.keymap.set

map("n", "<leader>fb", ":<C-U><C-R>=printf('Leaderf buffer %s', '')<CR><CR>")
map("n", "<leader>fm", ":<C-U><C-R>=printf('Leaderf mru %s', '')<CR><CR>")
map("n", "<leader>ft", ":<C-U><C-R>=printf('Leaderf bufTag %s', '')<CR><CR>")
map("n", "<leader>fl", ":<C-U><C-R>=printf('Leaderf line %s', '')<CR><CR>")
map("n", "<leader>fq", ":<C-U><C-R>=printf('Leaderf rg %s', '')<CR><CR>")
map("", "<C-B>", ":<C-U><C-R>=printf('Leaderf! rg --current-buffer -e %s ', expand('<cword>'))<CR>")
map("", "<C-F>", ":<C-U><C-R>=printf('Leaderf! rg -e %s ', expand('<cword>'))<CR>")
map("x", "gf", ":<C-U><C-R>=printf('Leaderf! rg -F -e %s ', leaderf#Rg#visual())<CR>")
map("", "go", ":<C-U>Leaderf! rg --recall<CR>")
map("n", "<leader>fr", ":<C-U><C-R>=printf('Leaderf! gtags -r %s --auto-jump', expand('<cword>'))<CR><CR>")
map("n", "<leader>fd", ":<C-U><C-R>=printf('Leaderf! gtags -d %s --auto-jump', expand('<cword>'))<CR><CR>")
map("n", "<leader>fo", ":<C-U><C-R>=printf('Leaderf! gtags --recall %s', '')<CR><CR>")
map("n", "<leader>fn", ":<C-U><C-R>=printf('Leaderf gtags --next %s', '')<CR><CR>")
map("n", "<leader>fp", ":<C-U><C-R>=printf('Leaderf gtags --previous %s', '')<CR><CR>")
