local function normalize_bufnr(bufnr)
  local value = tonumber(bufnr)
  if not value or value < 1 then
    return nil
  end
  return value
end

local function is_bufnr(bufnr)
  return normalize_bufnr(bufnr) ~= nil
end

local function get_diffview_buffers()
  local lib = require 'diffview.lib'
  local RevType = require('diffview.vcs.rev').RevType
  local view = lib.get_current_view()
  if not view or not view.cur_entry then
    return
  end

  local layout = view.cur_entry.layout
  local local_buf
  local stage_buf
  local commit_buf

  for _, win in ipairs { layout.a, layout.b, layout.c, layout.d } do
    if win and win.file and win.file.rev and is_bufnr(win.file.bufnr) then
      if win.file.rev.type == RevType.LOCAL then
        local_buf = win.file.bufnr
      elseif win.file.rev.type == RevType.STAGE then
        stage_buf = win.file.bufnr
      elseif win.file.rev.type == RevType.COMMIT then
        commit_buf = win.file.bufnr
      end
    end
  end

  if not is_bufnr(local_buf) and layout.get_main_win then
    local main = layout:get_main_win()
    if main and main.file and main.file.rev and main.file.rev.type == RevType.LOCAL and is_bufnr(main.file.bufnr) then
      local_buf = main.file.bufnr
    end
  end

  if not is_bufnr(local_buf) then
    local_buf = vim.api.nvim_get_current_buf()
  end

  return local_buf, stage_buf, commit_buf
end

local function diffput(source_buf, target_buf, whole_file, write_target)
  local source = normalize_bufnr(source_buf)
  local target = normalize_bufnr(target_buf)
  if not source or not target then
    return
  end

  vim.api.nvim_buf_call(target, function()
    vim.bo.modifiable = true
    vim.bo.readonly = false
  end)

  vim.api.nvim_buf_call(source, function()
    vim.cmd((whole_file and '%%diffput %d' or 'diffput %d'):format(target))
  end)

  if write_target then
    vim.api.nvim_buf_call(target, function()
      vim.cmd 'write'
    end)
  end
end

local function run_git(args, cwd)
  local cmd = { unpack(args) }

  if vim.system then
    vim.system(cmd, { cwd = cwd }):wait()
    return
  end

  if cwd then
    table.insert(cmd, 2, '-C')
    table.insert(cmd, 3, cwd)
  end

  vim.fn.system(cmd)
end

local function collect_diffview_paths(item)
  local paths = {}

  if item and item._node and item._node.leaves then
    for _, node in ipairs(item._node:leaves()) do
      if node.data and node.data.path then
        table.insert(paths, node.data.path)
      end
    end
  elseif item and item.path then
    table.insert(paths, item.path)
  end

  return paths
end

local function git_on_paths(mode, paths, cwd)
  if #paths == 0 then
    return
  end

  local cmd

  if mode == 'stage' then
    cmd = { 'git', 'add', '--' }
  elseif mode == 'unstage' then
    cmd = { 'git', 'restore', '--staged', '--' }
  elseif mode == 'discard' then
    cmd = { 'git', 'restore', '--staged', '--worktree', '--' }
  else
    return
  end

  for _, path in ipairs(paths) do
    table.insert(cmd, path)
  end

  run_git(cmd, cwd)
  require('diffview.actions').refresh_files()
end

local function git_on_selection(mode)
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if not view then
    return
  end

  local item = view:infer_cur_file(true)
  if not item then
    return
  end

  local paths = collect_diffview_paths(item)
  local cwd = view.adapter and view.adapter.ctx and view.adapter.ctx.toplevel or vim.fn.getcwd()
  git_on_paths(mode, paths, cwd)
end

local function git_on_current_file(mode)
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if not view then
    return
  end

  local item = view:infer_cur_file(false)
  if not item or not item.path then
    return
  end

  local cwd = view.adapter and view.adapter.ctx and view.adapter.ctx.toplevel or vim.fn.getcwd()
  git_on_paths(mode, { item.path }, cwd)
end

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
        view = {
          ['<leader>gs'] = function()
            local local_buf, stage_buf = get_diffview_buffers()
            diffput(local_buf, stage_buf, false, true)
          end,
          ['<leader>gS'] = function()
            git_on_current_file 'stage'
          end,
          ['<leader>gu'] = function()
            local _, stage_buf, commit_buf = get_diffview_buffers()
            diffput(commit_buf, stage_buf, false, true)
          end,
          ['<leader>gU'] = function()
            git_on_current_file 'unstage'
          end,
          ['<leader>gx'] = function()
            local local_buf, stage_buf = get_diffview_buffers()
            diffput(stage_buf, local_buf, false, true)
          end,
          ['<leader>gX'] = function()
            git_on_current_file 'discard'
          end,
        },

        file_panel = {
          ['<leader>gs'] = function()
            git_on_selection 'stage'
          end,
          ['<leader>gu'] = function()
            git_on_selection 'unstage'
          end,
          ['<leader>gx'] = function()
            git_on_selection 'discard'
          end,
          ['<leader>ga'] = function()
            require('diffview.actions').stage_all()
          end,
          ['<leader>gA'] = function()
            require('diffview.actions').unstage_all()
          end,
        },
      },
    },
  },
}
