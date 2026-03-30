local M = {}

-- Resolve the system Python at a known absolute path, immune to PATH manipulation.
local function get_system_python()
  if vim.fn.has("mac") == 1 then
    for _, prefix in ipairs({ "/opt/homebrew", "/usr/local" }) do
      local path = prefix .. "/bin/python3"
      if vim.uv.fs_stat(path) then
        return path
      end
    end
  end
  return "/usr/bin/python3"
end

-- Shell hooks (direnv, etc.) prepend project bin/ dirs to PATH that can contain
-- broken python3 wrapper scripts. Clean VIRTUAL_ENV/CONDA state and ensure the
-- system Python's directory is first in PATH so Mason always finds the real one.
local function sanitize_python_env(system_python)
  if vim.env.VIRTUAL_ENV then
    vim.env.VIRTUAL_ENV = nil
    vim.env.PYTHONHOME = nil
  end
  if vim.env.CONDA_PREFIX then
    vim.env.CONDA_PREFIX = nil
    vim.env.CONDA_DEFAULT_ENV = nil
  end

  local system_bin = vim.fn.fnamemodify(system_python, ":h")
  local path_parts = { system_bin }
  for part in (vim.env.PATH or ""):gmatch("[^:]+") do
    if part ~= system_bin then
      table.insert(path_parts, part)
    end
  end
  vim.env.PATH = table.concat(path_parts, ":")
end

local system_python = get_system_python()
sanitize_python_env(system_python)

local config = {
  python = system_python,
  venv_dir = vim.fn.stdpath("data") .. "/venv",
  version_file = vim.fn.stdpath("data") .. "/venv/venv_version.txt",
  packages = { "setuptools", "build", "wheel", "pynvim" },
}

config.venv_python = config.venv_dir .. "/bin/python"

local function get_system_python_version()
  local version_str = vim.fn.system({ config.python, "--version" })
  if vim.v.shell_error == 0 then
    return vim.trim(version_str)
  end

  vim.notify(
    "Could not detect system python version.", vim.log.levels.ERROR, { title = "Venv Setup" })

  return nil
end

local function get_venv_creation_version()
  local ok, file = pcall(io.open, config.version_file, "r")
  if not ok or not file then
    return nil
  end

  local version = file:read("*a")
  file:close()
  return vim.trim(version)
end

local function recreate_venv()
  vim.notify(
    "Recreating Python venv. Please wait...", vim.log.levels.INFO, { title = "Venv Setup" })

  vim.fn.system(
    { config.python, "-m", "venv", "--clear", "--upgrade-deps", config.venv_dir })

  local version_str = get_system_python_version()
  if version_str then
    local file = io.open(config.version_file, "w")
    if file then
      file:write(version_str)
      file:close()
    end
  end

  local pip_cmd = { config.venv_dir .. "/bin/python", "-m", "pip", "install", "--upgrade" }
  vim.list_extend(pip_cmd, config.packages)
  vim.fn.system(pip_cmd)

  vim.notify("Venv recreation complete.", vim.log.levels.INFO, { title = "Venv Setup" })
end

local function update_packages_background()
  if not vim.uv.fs_stat(config.venv_dir .. "/bin/python") then
    return
  end

  local cmd = { config.venv_dir .. "/bin/python", "-m", "pip", "install", "--upgrade" }
  vim.list_extend(cmd, config.packages)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify(
          "Venv package update failed in background.",
          vim.log.levels.WARN,
          { title = "Venv Setup" }
        )
      end
    end,
  })
end

function M.setup()
  local system_version = get_system_python_version()
  local venv_version = get_venv_creation_version()

  if not venv_version or (system_version and system_version ~= venv_version) then
    recreate_venv()
  end

  vim.g.python3_host_prog = config.venv_python
  update_packages_background()
end

return M
