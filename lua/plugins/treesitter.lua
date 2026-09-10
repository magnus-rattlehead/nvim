local treesitter = require("nvim-treesitter")

treesitter.setup()

if require("godot").is_project() then
  treesitter.install({ "gdscript", "godot_resource", "gdshader" })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "gdscript", "godot_resource", "gdshader" },
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
