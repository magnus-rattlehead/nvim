local leap = require("leap")

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap Forward" })
vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap Backward" })
vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "Leap From Window" })

leap.setup({
  max_phase_one_targets = nil,
  highlight_unlabeled_phase_one_targets = false,
})
