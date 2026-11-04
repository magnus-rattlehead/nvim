local M = {}
local installing = false
local install_dir = vim.fn.stdpath("data") .. "/mint"

function M.executable()
  for _, path in ipairs({ vim.fn.exepath("mint"), vim.fn.expand("~/.local/bin/mint"), install_dir .. "/bin/mint" }) do
    if path ~= "" and vim.fn.executable(path) == 1 then
      return path
    end
  end
end

function M.ensure_installed()
  if installing or M.executable() then
    return
  end
  for _, tool in ipairs({ "git", "zig" }) do
    if vim.fn.executable(tool) ~= 1 then
      vim.notify("Mint installation requires " .. tool .. " on PATH", vim.log.levels.WARN)
      return
    end
  end

  installing = true
  local source = vim.fn.tempname()
  vim.notify("Installing Mint…")

  local function finish(err)
    vim.fn.delete(source, "rf")
    installing = false
    if err then
      vim.notify("Mint installation failed: " .. err, vim.log.levels.ERROR)
    else
      vim.notify("Mint installed; Zig formatting is ready")
    end
  end

  local function run(command, options, next_step)
    local ok, err = pcall(vim.system, command, options, function(result)
      vim.schedule(function()
        if result.code ~= 0 then
          finish(result.stderr ~= "" and result.stderr or ("exit code " .. result.code))
        else
          next_step()
        end
      end)
    end)
    if not ok then
      finish(tostring(err))
    end
  end

  run({ "git", "clone", "--depth=1", "https://github.com/ziord/mint.git", source }, {
    text = true,
    timeout = 120000,
  }, function()
    run({ "zig", "build", "-Doptimize=ReleaseSafe", "--prefix", install_dir }, {
      cwd = source,
      text = true,
      timeout = 300000,
    }, function()
      finish(vim.fn.executable(install_dir .. "/bin/mint") ~= 1 and "build did not produce Mint" or nil)
    end)
  end)
end

return M
