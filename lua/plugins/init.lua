-- Bootstrap lazy.nvim
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
  -- LSP: installer
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function() require("plugins.lsp") end,
  },

  -- Completion engine
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

  -- Formatting (yapf for Python, prettier for JS/TS/JSON)
  {
    "stevearc/conform.nvim",
    config = function() require("plugins.conform") end,
  },

  -- Auto-close brackets/quotes
  "Raimondi/delimitMate",

  -- Fuzzy finder
  {
    "Yggdroot/LeaderF",
    build = ":LeaderfInstallCExtension",
    config = function() require("plugins.leaderf") end,
  },

  -- Symbol/LSP viewer sidebar
  {
    "liuchengxu/vista.vim",
    config = function() require("plugins.vista") end,
  },

  -- Status line (replaces vim-airline)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.lualine") end,
  },

  -- Git signs in gutter (replaces vim-gitgutter)
  {
    "lewis6991/gitsigns.nvim",
    config = function() require("plugins.gitsigns") end,
  },

  -- Git blame
  {
    "APZelos/blamer.nvim",
    config = function() require("plugins.blamer") end,
  },

  -- Highlight current paragraph
  "junegunn/limelight.vim",

  -- Color scheme (lua port of gruvbox)
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function() require("plugins.gruvbox") end,
  },

  -- Indent guides (replaces vim-indent-guides)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("plugins.indent-blankline") end,
  },

  -- Key binding helper (replaces vim-which-key)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("plugins.which-key") end,
  },

  -- Auto-detect shiftwidth/tabstop
  "tpope/vim-sleuth",

  -- File icons
  "nvim-tree/nvim-web-devicons",

  -- Move lines/selections up and down
  {
    "matze/vim-move",
    config = function() require("plugins.move") end,
  },

  -- Enhanced f/t navigation
  "justinmk/vim-sneak",

  -- Start screen (replaces vim-startify)
  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.alpha") end,
  },

  -- AI assistant
  {
    "Exafunction/windsurf.vim",
    config = function() require("plugins.windsurf") end,
  },

  -- File explorer (replaces NERDTree)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.nvim-tree") end,
  },

  -- Tag viewer (used by lualine tagbar component)
  "preservim/tagbar",

  -- Undo history visualizer
  {
    "mbbill/undotree",
    config = function() require("plugins.undotree") end,
  },

  -- Syntax/indent/language support (replaces vim-polyglot)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("plugins.treesitter") end,
  },
})
