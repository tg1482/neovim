local M = {}

function M.get_python_path(workspace)
  workspace = workspace or vim.fn.getcwd()

  -- Check for virtual environment
  local venv_path = workspace .. '/venv/bin/python'
  if vim.fn.executable(venv_path) == 1 then
    vim.notify('Using virtual environment: ' .. venv_path, vim.log.levels.INFO)
    return venv_path
  end

  -- Fall back to system Python
  local system_python = vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
  vim.notify('Using system Python: ' .. system_python, vim.log.levels.INFO)
  return system_python
end

return M
