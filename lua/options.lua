local opt = vim.opt

opt.history = 500
opt.autoread = true
opt.confirm = true
opt.timeoutlen = 300
opt.updatetime = 300
opt.encoding = "utf-8"
opt.fileformats = { "unix", "dos", "mac" }
opt.clipboard = "unnamedplus"

opt.termguicolors = true
opt.background = "dark"
opt.relativenumber = true
opt.ruler = true
opt.cmdheight = 1
opt.showmode = false
opt.showtabline = 2
opt.signcolumn = "yes"
opt.laststatus = 2

opt.scrolloff = 15
opt.textwidth = 100
opt.wrap = true
opt.linebreak = true
opt.showbreak = "↪ "

opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "split"
opt.magic = true
opt.showmatch = true
opt.matchtime = 2
opt.regexpengine = 0

opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

opt.whichwrap = "b,s,<,>,h,l,["

opt.wildmenu = true
opt.wildignore = { "*.o", "*~", "*.pyc", "*/.git/*", "*/.hg/*", "*/.svn/*", "*/.DS_Store" }
opt.switchbuf = { "useopen", "usetab", "newtab" }
opt.backspace = { "eol", "start", "indent" }

opt.list = true
opt.listchars = { tab = "→ ", eol = "↲", space = "␣", trail = "•", extends = "»", precedes = "«", nbsp = "‡" }

opt.errorbells = false
opt.visualbell = false
