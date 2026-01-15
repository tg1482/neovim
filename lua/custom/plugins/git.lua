return {
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { desc = 'Go to next hunk', expr = true })

        map('n', '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { desc = 'Go to prev hunk', expr = true })

        -- Keep only non-staging actions
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git Preview Hunk' })
        map('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'Git Blame Line' })

        -- Toggles
        map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle Git Blame Line' })
        map('n', '<leader>tgd', gs.toggle_deleted, { desc = 'Toggle Git Show Deleted' })
      end,
    },
  },

  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Open Diffview' },
      { '<leader>gdh', '<cmd>DiffviewFileHistory<cr>', desc = 'Open Diffview File History' },
      { '<leader>gdc', '<cmd>DiffviewClose<cr>', desc = 'Close Diffview' },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = 'diff2_horizontal' },
        merge_tool = { layout = 'diff3_horizontal', disable_diagnostics = true },
        file_history = { layout = 'diff2_horizontal' },
      },

      keymaps = {
        view = function(bufnr)
          local actions = require 'diffview.actions'
          vim.keymap.set('n', '<leader>gs', actions.stage_hunk, { buffer = bufnr, desc = 'Stage Hunk' })
          vim.keymap.set('n', '<leader>gu', actions.unstage_hunk, { buffer = bufnr, desc = 'Unstage Hunk' })
          vim.keymap.set('n', '<leader>gp', actions.preview_hunk, { buffer = bufnr, desc = 'Preview Hunk' })
          vim.keymap.set('n', '<leader>gS', actions.stage_file, { buffer = bufnr, desc = 'Stage File' })
          vim.keymap.set('n', '<leader>gU', actions.unstage_file, { buffer = bufnr, desc = 'Unstage File' })
        end,

        file_panel = function(bufnr)
          local actions = require 'diffview.actions'
          vim.keymap.set('n', '<leader>ga', actions.stage_all, { buffer = bufnr, desc = 'Stage All' })
          vim.keymap.set('n', '<leader>gA', actions.unstage_all, { buffer = bufnr, desc = 'Unstage All' })
        end,
      },
    },
  },
}
