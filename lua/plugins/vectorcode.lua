local bin = vim.fn.expand("~/.local/bin/")
vim.lsp.config("vectorcode_server", {
  cmd = { bin .. "vectorcode-server" },
  cmd_env = { OMP_NUM_THREADS = "2", MKL_NUM_THREADS = "2", OPENBLAS_NUM_THREADS = "2" },
})

require("vectorcode").setup({
  cli_cmds = { vectorcode = bin .. "vectorcode" },
  async_backend = "lsp",
  -- The CLI requires a positive integer; request every available document.
  n_query = 2147483647,
  notify = false,
  async_opts = { debounce = 1, run_on_register = true },
})

local cacher = require("vectorcode.config").get_cacher_backend()
local runner = require("vectorcode.jobrunner.lsp")
local indexed = {}

local function register(buf, root)
  if vim.api.nvim_buf_is_loaded(buf) and not cacher.buf_is_registered(buf) then
    cacher.register_buffer(buf, { project_root = root })
  end
end

local function index_buffer(event)
  local buf = event.buf
  if not vim.api.nvim_buf_is_loaded(buf) then return end
  if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then return end
  local path = vim.api.nvim_buf_get_name(buf)
  if vim.fn.filereadable(path) ~= 1 then return end
  local root = require("vectorcode.utils").find_root(path)
  if not root then return end
  if indexed[root] == "pending" then return end
  if indexed[root] and event.event ~= "BufWritePost" then
    register(buf, root)
    return
  end

  local full = not indexed[root]
  if full then indexed[root] = "pending" end
  local args = { "vectorise", "--pipe", "--project_root", root }
  if full then args[#args + 1] = "-r" end
  vim.list_extend(args, { "--", full and root or path })
  runner.run_async(args, function(result, err, code)
    if code ~= 0 or not result or (tonumber(result.failed) or 0) > 0 then
      if full then indexed[root] = nil end
      vim.notify("VectorCode indexing failed: " .. table.concat(err or {}, "\n"), vim.log.levels.WARN)
      return
    end
    indexed[root] = true
    register(buf, root)
    local current = vim.api.nvim_get_current_buf()
    if require("vectorcode.utils").find_root(current) == root then register(current, root) end
  end, buf)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  group = vim.api.nvim_create_augroup("VectorCodeAutoIndex", { clear = true }),
  callback = index_buffer,
  desc = "Index projects on first visit and update saved files",
})
-- Lazy can configure this plugin before the command-line file is loaded.
vim.schedule(function()
  index_buffer({ buf = vim.api.nvim_get_current_buf(), event = "BufEnter" })
end)
