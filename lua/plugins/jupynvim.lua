require("jupynvim").setup({
  log_level = "info",
  image_renderer = "placeholder", -- Inline images in Kitty-compatible terminals.
  auto_venv = true,

  -- Keep the existing nvim-tree and Telescope mappings.
  explorer_keys = {},
  explorer_cwd_keys = {},
  pick_keys = { files = {}, grep = {} },
})
