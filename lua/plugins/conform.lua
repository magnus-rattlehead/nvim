require("conform").setup({
  formatters_by_ft = {
    python     = { "yapf" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json       = { "prettier" },
    css        = { "prettier" },
    html       = { "prettier" },
  },
  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
})

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})
