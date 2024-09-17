-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<C-v>'] = 'open_vsplit',
          ['<C-x>'] = 'open_split',
          ['<C-t>'] = 'open_tabnew',
          ['<C-o>'] = function(state)
            -- Get the current file's directory
            local node = state.tree:get_node()
            local path = node:get_id()
            local dir = vim.fn.fnamemodify(path, ':p:h') -- get the directory

            -- Path to your AppleScript
            local applescript_path = '~/.config/nvim/bin/open_iterm_and_nvim.scpt'

            -- Run the AppleScript with the directory as argument
            vim.fn.system('osascript ' .. applescript_path .. ' ' .. vim.fn.shellescape(dir))
          end,
        },
      },
    },
  },
}
