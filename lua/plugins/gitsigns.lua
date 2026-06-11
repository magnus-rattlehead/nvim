require("gitsigns").setup({
  signs                        = {
    add          = { text = "┃" },
    change       = { text = "┃" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
    untracked    = { text = "┆" },
  },
  signcolumn                   = true,
  numhl                        = false,
  linehl                       = false,
  word_diff                    = false,

  current_line_blame           = true,
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = "eol",
    delay = 400,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "   • <author>, <author_time:%Y-%m-%d> - <summary>",

  max_file_length              = 40000,
})

vim.keymap.set("n", "<leader>tb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle Git Blame Inline" })

vim.keymap.set("n", "<leader>hp", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview Git Hunk" })
