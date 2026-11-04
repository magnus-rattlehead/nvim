local default_config = vim.fn.stdpath("config") .. "/formatters/mint.zon"

return {
  meta = {
    url = "https://github.com/ziord/mint",
    description = "Mint with project mint.zon or the Neovim defaults.",
  },
  format = function(_, ctx, lines, callback)
    local mint = require("formatters.mint_install").executable()
    if not mint then
      callback("Mint is not available yet; opening a Zig file starts automatic installation")
      return
    end

    -- Look from the file toward the project root, without crossing a Git root.
    local root = vim.fs.root(ctx.dirname, { ".git" })
    local config = vim.fs.find("mint.zon", {
      path = ctx.dirname,
      upward = true,
      type = "file",
      stop = root and vim.fs.dirname(root) or nil,
    })[1]

    -- Mint has no stdin/--config support. Only stage this buffer and its config;
    -- never ask Mint to scan or rewrite the user's project.
    local temporary = vim.fn.tempname()
    local relative = config and vim.fs.relpath(vim.fs.dirname(config), ctx.filename)
      or vim.fs.basename(ctx.filename)
    if not relative or relative == "" then
      relative = "buffer.zig"
    end
    local input = temporary .. "/" .. relative
    local ok, err = pcall(function()
      vim.fn.mkdir(vim.fs.dirname(input), "p", 448)
      assert(vim.fn.writefile(lines, input) == 0, "Unable to stage the Zig buffer")
      assert(
        vim.fn.writefile(vim.fn.readfile(config or default_config), temporary .. "/mint.zon") == 0,
        "Unable to stage mint.zon"
      )
    end)
    if not ok then
      vim.fn.delete(temporary, "rf")
      callback(tostring(err))
      return
    end

    local function finish(result)
      vim.schedule(function()
        local output
        local failure
        if result.code ~= 0 or result.stderr:find("error:", 1, true) then
          failure = result.stderr ~= "" and result.stderr or ("Mint exited with code " .. result.code)
        else
          local read_ok, contents = pcall(vim.fn.readfile, input)
          if read_ok then
            output = contents
          else
            failure = tostring(contents)
          end
        end
        vim.fn.delete(temporary, "rf")
        callback(failure, output)
      end)
    end

    local started, process_error = pcall(vim.system, { mint, "fmt", temporary }, {
      text = true,
      timeout = 1800,
    }, finish)
    if not started then
      vim.fn.delete(temporary, "rf")
      callback(tostring(process_error))
    end
  end,
}
