local cmp = require("cmp")
local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
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
      local codeium_visible = vim.fn.exists("*codeium#GetStatusString") == 1 and
          vim.fn["codeium#GetStatusString"]():match("0") == nil and vim.fn["codeium#GetStatusString"]() ~= ""
      if codeium_visible then
        fallback()
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
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
})
