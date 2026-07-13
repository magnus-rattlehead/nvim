require("mason").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gy", require("telescope.builtin").lsp_type_definitions, "Go to type definition")
    map("n", "gi", require("telescope.builtin").lsp_implementations, "Go to implementation")
    map("n", "gr", require("telescope.builtin").lsp_references, "Go to references")
    map("n", "P", vim.lsp.buf.hover, "Hover")

    map("n", "[g", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("n", "]g", vim.diagnostic.goto_next, "Next diagnostic")
    map("n", "grn", vim.lsp.buf.rename, "Rename")

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
  end,
})

vim.diagnostic.config({
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = { spacing = 4 },
  severity_sort = true,
})

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--completion-style=detailed",
    "--fallback-style=llvm",
  },
  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".git",
  },
})

vim.lsp.config("pyright", {
  workspace_required = true,
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".venv",
    "venv",
  },
  settings = {
    python = {
      analysis = {
        exclude = { "**/node_modules", "**/dist", "**/.venv", "venv" },
        useLibraryCodeForTypes = true,
      },
    },
  },
})

vim.lsp.config("vue_ls", {
  root_markers = { "package.json", "vue.config.js", "vite.config.js" },
})

vim.lsp.config("vtsls", {
  workspace_required = true,
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json" },
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
})
