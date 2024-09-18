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

        -- Actions
        map('n', '<leader>gs', gs.stage_hunk, { desc = 'Git Stage Hunk' })
        map('n', '<leader>gr', gs.reset_hunk, { desc = 'Git Reset Hunk' })
        map('v', '<leader>gs', function()
          gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git Stage Selected Hunks' })
        map('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Git Reset Selected Hunks' })
        map('n', '<leader>gS', gs.stage_buffer, { desc = 'Git Stage Buffer' })
        map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Git Undo Stage Hunk' })
        map('n', '<leader>gR', gs.reset_buffer, { desc = 'Git Reset Buffer' })
        map('n', '<leader>gp', gs.preview_hunk, { desc = 'Git Preview Hunk' })
        map('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'Git Blame Line' })
        map('n', '<leader>gd', gs.diffthis, { desc = 'Git Diff This' })
        map('n', '<leader>gD', function()
          gs.diffthis '~'
        end, { desc = 'Git Diff This ~' })

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
    },
  },
}
