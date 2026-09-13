require("mason").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }

local hover_timers = {}
local hover_delay_ms = 1000

local function close_hover_timer(bufnr)
  local timer = hover_timers[bufnr]
  if timer then
    timer:stop()
    timer:close()
    hover_timers[bufnr] = nil
  end
end

local function schedule_hover(bufnr)
  close_hover_timer(bufnr)

  if vim.fn.mode() ~= "n" then
    return
  end

  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local symbol = vim.fn.expand("<cword>")
  if symbol == "" then
    return
  end

  local timer = vim.uv.new_timer()
  hover_timers[bufnr] = timer

  timer:start(hover_delay_ms, 0, function()
    vim.schedule(function()
      close_hover_timer(bufnr)

      if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(win) then
        return
      end

      if vim.api.nvim_get_current_buf() ~= bufnr or vim.api.nvim_get_current_win() ~= win then
        return
      end

      if vim.fn.mode() ~= "n" or vim.fn.pumvisible() == 1 then
        return
      end

      local current_cursor = vim.api.nvim_win_get_cursor(win)
      if current_cursor[1] ~= cursor[1] or current_cursor[2] ~= cursor[2] then
        return
      end

      if vim.fn.expand("<cword>") ~= symbol then
        return
      end

      if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" }) > 0 then
        vim.lsp.buf.hover()
      end
    end)
  end)
end

vim.lsp.config("*", {
  capabilities = capabilities,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    require("keymaps").lsp(bufnr)

    local grp = vim.api.nvim_create_augroup("LspDocumentHighlight" .. bufnr, { clear = true })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      group = grp,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/documentHighlight" }) > 0 then
          vim.lsp.buf.document_highlight()
        end
      end,
    })
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      group = grp,
      callback = vim.lsp.buf.clear_references,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
      buffer = bufnr,
      group = grp,
      callback = function()
        schedule_hover(bufnr)
      end,
    })
    vim.api.nvim_create_autocmd({ "CursorMovedI", "InsertEnter", "BufLeave", "WinLeave" }, {
      buffer = bufnr,
      group = grp,
      callback = function()
        close_hover_timer(bufnr)
      end,
    })
    schedule_hover(bufnr)

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
    "uv.lock",
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".venv",
    "venv",
    ".git",
    ".vectorcode",
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

-- Godot provides this language server while the editor and project are open.
vim.lsp.enable("gdscript")

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
