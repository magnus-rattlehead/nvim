local M = {}

local project_file = vim.fs.find("project.godot", {
  path = vim.uv.cwd(),
  upward = true,
})[1]

M.project_root = project_file and vim.fs.dirname(project_file) or nil

function M.is_project()
  return M.project_root ~= nil
end

local function start_server()
  if not M.project_root then
    return
  end

  local pipe = M.project_root .. "/server.pipe"
  local running_servers = vim.fn.serverlist()

  if not vim.tbl_contains(running_servers, pipe) then
    local ok, address = pcall(vim.fn.serverstart, pipe)
    if not ok then
      vim.notify("Could not start the Godot Neovim server: " .. address, vim.log.levels.WARN)
      return
    end

    M.server_address = address
  else
    M.server_address = pipe
  end
end

local function create_commands()
  vim.api.nvim_create_user_command("GodotBreakpoint", function()
    vim.cmd("normal! obreakpoint")
    vim.cmd.write()
  end, { desc = "Insert and save a GDScript breakpoint" })

  vim.api.nvim_create_user_command("GodotDeleteBreakpoints", function()
    vim.cmd([[silent! g/^\s*breakpoint\s*$/d]])
  end, { desc = "Delete breakpoints from the current buffer" })

  vim.api.nvim_create_user_command("GodotFindBreakpoints", function()
    local result = vim.system({
      "rg",
      "--vimgrep",
      "--glob",
      "*.gd",
      "--",
      [[^\s*breakpoint\s*$]],
      M.project_root,
    }, { text = true }):wait()

    vim.fn.setqflist({}, " ", {
      title = "Godot breakpoints",
      lines = vim.split(result.stdout or "", "\n", { trimempty = true }),
      efm = "%f:%l:%c:%m",
    })

    if #vim.fn.getqflist() > 0 then
      vim.cmd.copen()
    else
      vim.notify("No breakpoints found", vim.log.levels.INFO)
    end
  end, { desc = "Find project breakpoints" })

  vim.api.nvim_create_user_command("GodotTranslators", function()
    vim.cmd("normal! A # TRANSLATORS: ")
  end, { desc = "Append a Godot translator comment" })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "gdscript",
    callback = function(args)
      require("keymaps").godot(args.buf)
    end,
  })
end

function M.setup()
  vim.g.is_godot_project = M.is_project()
  vim.g.godot_project_root = M.project_root

  if not M.is_project() then
    return
  end

  start_server()
  create_commands()
end

return M
