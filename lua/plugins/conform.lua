require("conform").setup({
  formatters_by_ft = {
    python     = { "yapf" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    json       = { "prettier" },
    css        = { "prettier" },
    html       = { "prettier" },
  },
  format_on_save = function(bufnr)
    -- Notebook buffers contain rendered cells, markdown, and outputs.
    if vim.api.nvim_buf_get_name(bufnr):match("%.ipynb$") then
      return
    end
    return { timeout_ms = 1000, lsp_fallback = true }
  end,
})

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})
