require("telescope").setup({
  defaults = {
    winblend = 0,
    mappings = require("keymaps").telescope_mappings(),
  },
})

require("keymaps").telescope()
