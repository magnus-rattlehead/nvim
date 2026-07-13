local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- LSP & Completion
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function() require("plugins.lsp") end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function() require("plugins.cmp") end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function() require("plugins.conform") end,
  },

  -- Navigation & UI
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function() require("plugins.telescope") end,
  },

  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    opts = {},
  },

  {
    "nvim-mini/mini.icons",
    version = false,
    config = function()
      require("plugins.icons")
    end,
  },

  {
    "echasnovski/mini.statusline",
    version = "*",
    dependencies = { "nvim-mini/mini.icons" },
    config = function()
      require("plugins.statusline")
    end,
  },

  {
    "echasnovski/mini.tabline",
    version = "*",
    config = function()
      require("plugins.tabline")
    end,
  },

  {
    "rmagatti/auto-session",
    lazy = false,
    config = function() require("plugins.auto-session") end,
    keys = {
      { "<leader>qs", "<cmd>AutoSession save<cr>", desc = "Save session" },
      { "<leader>qr", "<cmd>AutoSession restore<cr>", desc = "Restore session" },
      { "<leader>qS", "<cmd>AutoSession search<cr>", desc = "Search sessions" },
      { "<leader>qa", "<cmd>AutoSession toggle<cr>", desc = "Toggle autosave" },
    },
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    config = function() require("plugins.gitsigns") end,
  },


  -- Aesthetics & Editing
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function() require("plugins.cyberdream") end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("plugins.indent-blankline") end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("plugins.which-key") end,
  },

  "tpope/vim-sleuth",

  {
    "matze/vim-move",
    config = function() require("plugins.move") end,
  },

  {
    "Exafunction/windsurf.vim",
    config = function() require("plugins.windsurf") end,
  },

  -- File Trees & History
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-mini/mini.icons" },
    config = function() require("plugins.nvim-tree") end,
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function() require("plugins.undotree") end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("plugins.treesitter") end,
  },

  -- Core Motions & Typing Utilities
  {
    "echasnovski/mini.pairs",
    version = "*",
    config = true,
  },

  {
    url = "https://codeberg.org/andyg/leap.nvim",
    name = "leap.nvim",
    config = function() require("plugins.leap") end,
  },

  {
    "MagicDuck/grug-far.nvim",
    lazy = false,
    keys = {
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
    },
    config = function()
      require("grug-far").setup({
        windowCreationCommand = "vsplit",
        helpLine = { enable = false },
        icons = { enabled = true },
      })
    end,
  },

})
