return {
  'hkupty/iron.nvim',
  lazy = true,
  keys = {
    { '<space>rs', '<cmd>IronRepl<cr>', desc = 'Start REPL' },
    { '<space>rr', '<cmd>IronRestart<cr>', desc = 'Restart REPL' },
    { '<space>rh', '<cmd>IronHide<cr>', desc = 'Hide REPL' },
  },
  config = function()
    local iron = require 'iron.core'
    local python_path_finder = require 'bin.python_path_finder'

    iron.setup {
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { 'zsh' },
          },
          python = {
            -- Use a function to determine the Python command dynamically
            command = { python_path_finder.get_python_path() },
            format = require('iron.fts.common').bracketed_paste_python,
          },
        },
        repl_open_cmd = require('iron.view').bottom(20),
      },
      keymaps = {
        send_file = '<space>rf',
        send_line = '<space>rl',
        send_paragraph = '<space>rp',
        send_until_cursor = '<space>ru',
        interrupt = '<space>r<space>',
        exit = '<space>rq',
        clear = '<space>rcl',
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    }

    -- Optional: Add a command to display the current Python path
    vim.api.nvim_create_user_command('IronPythonPath', function()
      print('Current Python path: ' .. get_python_path())
    end, {})
  end,
}
