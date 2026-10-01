local function line_width(bufnr)
  local width = vim.bo[bufnr].textwidth
  return width > 0 and width or 100
end

local function lsp_format(bufnr)
  local ft = vim.bo[bufnr].filetype
  if ft == "markdown" or ft == "markdown.mdx" or ft == "text" then
    return "never"
  end
  return "prefer"
end

require("conform").setup({
  formatters_by_ft = {
    -- Prefer a formatting-capable LSP; these are language-specific fallbacks.
    c          = { "clang-format" },
    cpp        = { "clang-format" },
    objc       = { "clang-format" },
    objcpp     = { "clang-format" },
    go         = { "gofmt" },
    rust       = { "rustfmt" },
    lua        = { "stylua" },
    sh         = { "shfmt" },
    bash       = { "shfmt" },
    gdscript   = { "gdformat" },
    zig        = { "zigfmt" },
    python     = { "yapf" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    vue        = { "prettier" },
    json       = { "prettier" },
    jsonc      = { "prettier" },
    css        = { "prettier" },
    scss       = { "prettier" },
    less       = { "prettier" },
    html       = { "prettier" },
    yaml       = { "prettier" },
    markdown   = { "prettier" },
    ["markdown.mdx"] = { "prettier" },
    -- Never apply paragraph wrapping to code or unknown filetypes.
    text       = { "text_wrap" },
  },
  formatters = {
    prettier = {
      prepend_args = function(_, ctx)
        local args = { "--print-width", tostring(line_width(ctx.buf)), "--config-precedence", "prefer-file" }
        local ft = vim.bo[ctx.buf].filetype
        if ft == "markdown" or ft == "markdown.mdx" then
          vim.list_extend(args, { "--prose-wrap", "always" })
        end
        return args
      end,
    },
    text_wrap = {
      command = "fmt",
      args = function(_, ctx)
        return { "--width", tostring(line_width(ctx.buf)) }
      end,
      stdin = true,
    },
  },
  format_on_save = function(bufnr)
    -- Notebook buffers contain rendered cells, markdown, and outputs.
    if vim.api.nvim_buf_get_name(bufnr):match("%.ipynb$") then
      return
    end
    return { timeout_ms = 2000, lsp_format = lsp_format(bufnr) }
  end,
})

vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_format = lsp_format(0) })
end, {})
