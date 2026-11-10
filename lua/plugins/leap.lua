require("keymaps").leap()

-- Show selectable labels only after both search characters have been typed.
-- Keep labels beside the match so the original text stays readable.
local opts = require("leap").opts
opts.preview = false
opts.offset_labels = true
