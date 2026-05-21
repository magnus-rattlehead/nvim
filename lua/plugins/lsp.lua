local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  -- Navigation
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gy", vim.lsp.buf.type_definition)
  map("n", "gi", vim.lsp.buf.implementation)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "P",  vim.lsp.buf.hover)

  -- Diagnostics
  map("n", "[g", vim.diagnostic.goto_prev)
  map("n", "]g", vim.diagnostic.goto_next)

  -- Refactor
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action)
  map("n", "<leader>ac", vim.lsp.buf.code_action)
  map("n", "<leader>qf", vim.lsp.buf.code_action)

  -- Highlight symbol + refs on hold
  local grp = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    buffer = bufnr,
    group = grp,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    group = grp,
    callback = vim.lsp.buf.clear_references,
  })

  -- Organize imports (replaces coc OR command)
  vim.api.nvim_buf_create_user_command(bufnr, "OR", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.organizeImports" } },
    })
  end, {})
end

-- Diagnostic display
vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4 },
  severity_sort = true,
})

require("mason").setup()

require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "ts_ls",
    "jsonls",
    "clangd",
    "lua_ls",
    "bashls",
  },
  handlers = {
    -- Default handler
    function(server)
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    -- lua_ls: teach it about the neovim runtime
    lua_ls = function()
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })
    end,

    -- pyright: match original coc root patterns
    pyright = function()
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern(
          ".git", ".env", "venv", ".venv",
          "setup.cfg", "setup.py", "pyproject.toml", "pyrightconfig.json"
        ),
      })
    end,
  },
})
