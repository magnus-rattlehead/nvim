-- Custom keybindings live here; plugin configs call these helpers when ready.
local M = {}

function M.setup()
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
end

function M.gitsigns()
  vim.keymap.set("n", "<leader>tb", function()
    require("gitsigns").toggle_current_line_blame()
  end, { desc = "Toggle Git Blame Inline" })

  vim.keymap.set("n", "<leader>hp", function()
    require("gitsigns").preview_hunk()
  end, { desc = "Preview Git Hunk" })
end

function M.nvim_tree()
  vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")
end

function M.minuet()
  local action = require("minuet.virtualtext").action
  vim.keymap.set("i", ".m", function()
    if not action.is_visible() then return ".m" end
    vim.schedule(action.accept_line)
    return ""
  end, { silent = true, nowait = true, expr = true, desc = "Accept AI suggestion line" })
  vim.keymap.set("i", "<M-]>", action.next, { desc = "Request/next AI suggestion" })
  vim.keymap.set("i", "<M-[>", action.prev, { desc = "Previous AI suggestion" })
  vim.keymap.set("i", "<M-e>", action.dismiss, { desc = "Dismiss AI suggestion" })
end

function M.leap()
  vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap Forward" })
  vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap Backward" })
  vim.keymap.set({ "n", "x", "o" }, "gs", "<Plug>(leap-from-window)", { desc = "Leap From Window" })
end

function M.move()
  vim.g.move_key_modifier = "S"
  vim.g.move_key_modifier_visual = "S"
end

function M.telescope_mappings()
  local actions = require("telescope.actions")
  return {
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
  }
end

function M.telescope()
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
end

function M.cmp()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  return cmp.mapping.preset.insert({
    ["<CR>"]      = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behaviour = cmp.ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
    ["<C-e>"]     = cmp.mapping.abort(),
    ["<Tab>"]     = cmp.mapping(function(fallback)
      local minuet = package.loaded["minuet.virtualtext"]
      if minuet and minuet.action.is_visible() and not cmp.visible() then
        minuet.action.accept()
      elseif cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"]   = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  })
end

function M.lsp(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "gy", require("telescope.builtin").lsp_type_definitions, "Go to type definition")
  map("n", "gi", require("telescope.builtin").lsp_implementations, "Go to implementation")
  map("n", "gr", require("telescope.builtin").lsp_references, "Go to references")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "P", vim.lsp.buf.hover, "Hover")

  map("n", "[g", vim.diagnostic.goto_prev, "Previous diagnostic")
  map("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "grn", vim.lsp.buf.rename, "Rename")
end

M.auto_session = {
  { "<leader>qs", "<cmd>AutoSession save<cr>", desc = "Save session" },
  { "<leader>qr", "<cmd>AutoSession restore<cr>", desc = "Restore session" },
  { "<leader>qS", "<cmd>AutoSession search<cr>", desc = "Search sessions" },
  { "<leader>qa", "<cmd>AutoSession toggle<cr>", desc = "Toggle autosave" },
}

M.bitwise = {
  { "<leader>bv", "<cmd>BitwiseVisualizerToggle<cr>", desc = "Toggle bitwise visualizer" },
}

M.grug_far = {
  {
    "<leader>sr",
    function()
      require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
    end,
    desc = "Search & Replace (Workspace)"
  },

  {
    "<leader>sr",
    function()
      require("grug-far").withMode("visual")
    end,
    mode = "v",
    desc = "Search & Replace (Selection)"
  },

  {
    "<leader>sf",
    function()
      local current_file = vim.fn.expand("%:.")
      require("grug-far").open({
        prefills = {
          search = vim.fn.expand("<cword>"),
          filesFilter = current_file,
        },
        staticTitle = "Grug-Far: Single File [" .. vim.fn.expand("%:t") .. "]"
      })
    end,
    desc = "Search & Replace (Current File)"
  },
}
M.undotree = {
  { "<C-u>", "<Cmd>UndotreeToggle<CR>", desc = "Toggle Undo Tree" },
}

function M.godot(bufnr)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "<leader>gb", "<cmd>GodotBreakpoint<cr>",
    vim.tbl_extend("force", opts, { desc = "Godot breakpoint" }))
  vim.keymap.set("n", "<leader>gD", "<cmd>GodotDeleteBreakpoints<cr>",
    vim.tbl_extend("force", opts, { desc = "Godot delete breakpoints" }))
  vim.keymap.set("n", "<leader>gF", "<cmd>GodotFindBreakpoints<cr>",
    vim.tbl_extend("force", opts, { desc = "Godot find breakpoints" }))
  vim.keymap.set("n", "<leader>gt", "<cmd>GodotTranslators<cr>",
    vim.tbl_extend("force", opts, { desc = "Godot translator comment" }))
end

return M
