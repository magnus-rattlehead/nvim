local actions = require("telescope.actions")

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,
      },
      n = {
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },

  },
})

local builtin = require("telescope.builtin")
local map = vim.keymap.set

map("n", "<leader><leader>", builtin.find_files, { desc = "Search Everywhere" })

map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })

map("n", "<leader>fb", builtin.buffers, { desc = "Find Open Buffers" })

map("n", "<leader>fm", builtin.oldfiles, { desc = "Find Recent Files" })

map("n", "<leader>ft", builtin.current_buffer_tags, { desc = "Find Buffer Tags" })

map("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })

map("n", "<leader>fq", builtin.live_grep, { desc = "Live Grep Workspace" })

map("n", "<C-B>", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>"), only_sort_text = true })
end, { desc = "Search word in buffer" })

map("n", "<C-F>", function()
  builtin.grep_string({ search = vim.fn.expand("<cword>") })
end, { desc = "Search word in project" })

map("x", "gf", function()
  local mode = vim.fn.visualmode()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = mode })

  local query = table.concat(lines, " "):gsub("%s+", " "):match("^%s*(.-)%s*$")

  if query and query ~= "" then
    builtin.grep_string({ search = query })
  end
end, { desc = "Search visual selection in project" })

map("n", "go", builtin.resume, { desc = "Resume Last Telescope Picker" })

map("n", "<leader>fr", builtin.lsp_references, { desc = "LSP References (Global)" })
map("n", "<leader>fd", builtin.lsp_definitions, { desc = "LSP Definitions (Global)" })
map("n", "<leader>fo", builtin.lsp_implementations, { desc = "LSP Implementations (Global)" })
