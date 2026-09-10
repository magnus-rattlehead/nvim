local godot = require("godot")

require("nvim-tree").setup({
  filters = {
    custom = function(path)
      if not godot.is_project() then
        return false
      end

      local name = vim.fs.basename(path)
      return name == "server.pipe" or vim.endswith(name, ".uid")
    end,
  },
})

require("keymaps").nvim_tree()
