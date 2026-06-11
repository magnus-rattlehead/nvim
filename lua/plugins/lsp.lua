require("mason").setup()

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true })
  end

  map("n", "gd", require("telescope.builtin").lsp_definitions)
  map("n", "gy", require("telescope.builtin").lsp_type_definitions)
  map("n", "gi", require("telescope.builtin").lsp_implementations)
  map("n", "gr", require("telescope.builtin").lsp_references)
  map("n", "P", vim.lsp.buf.hover)

  map("n", "[g", vim.diagnostic.goto_prev)
  map("n", "]g", vim.diagnostic.goto_next)
  map("n", "grn", vim.lsp.buf.rename)

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

  vim.api.nvim_buf_create_user_command(bufnr, "OR", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.organizeImports" } },
    })
  end, {})
end

vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4 },
  severity_sort = true,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright",
    "ts_ls",
    "vtsls",
    "vue_ls",
    "jsonls",
    "clangd",
    "lua_ls",
    "bashls",
    "cssls",
    "html",
    "yamlls",
  },
  handlers = {
    function(server)
      lspconfig[server].setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    lua_ls = function()
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,

    pyright = function()
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = false,
        root_dir = lspconfig.util.root_pattern(
          "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".venv", "venv"
        ),
        settings = {
          python = {
            analysis = {
              exclude = { "**/node_modules", "**/dist", "**/.venv", "venv" },
              useLibraryCodeForTypes = true,
            }
          }
        }
      })
    end,

    vue_ls = function()
      lspconfig.vue_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = lspconfig.util.root_pattern("package.json", "vue.config.js", "vite.config.js"),
      })
    end,

    vtsls = function()
      lspconfig.vtsls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        single_file_support = false,
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
        settings = {
          vtsls = {
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = { enableServerSideFilter = true },
            },
          },
          typescript = {
            tserver = {
              pluginPaths = { "./node_modules/@vue/typescript-plugin" },
            },
          },
        },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
      })
    end,
  },
})
