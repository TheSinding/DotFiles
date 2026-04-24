local actions = require 'telescope.actions'

-- Re-arm which-key after telescope closes, otherwise <leader> stops working.
-- <Ignore> is a built-in Neovim no-op that pokes the key processor back awake.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'TelescopePrompt',
  callback = function()
    vim.api.nvim_create_autocmd('BufWinLeave', {
      buffer = 0,
      once = true,
      callback = function()
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Ignore>', true, false, true), 'n', false)
        end)
      end,
    })
  end,
})

return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', opt = {} },
  },
  config = function()
    local excluded_ft = { 'neo-tree', 'neo-tree-popup', 'notify' }
    local excluded_bt = { 'terminal', 'quickfix' }

    local function pick_window_and_open(prompt_bufnr)
      local action_state = require 'telescope.actions.state'
      local entry = action_state.get_selected_entry()
      if not entry then
        return
      end
      actions.close(prompt_bufnr)
      local filepath = entry.path or entry.filename
      if not filepath then
        return
      end
      local ok, wp = pcall(require, 'window-picker')
      local picked_win = nil
      if ok then
        -- include_current_win=true mirrors neo-tree's effective behaviour: neo-tree's window is
        -- excluded by filetype anyway, so all editing windows are pickable there. Passing true
        -- here means the window that launched telescope is also a valid pick target, giving the
        -- same window count. The pre-check avoids the picker's "no windows" warning.
        local has_real_win = false
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(w)
          if not vim.tbl_contains(excluded_ft, vim.bo[buf].filetype)
            and not vim.tbl_contains(excluded_bt, vim.bo[buf].buftype) then
            has_real_win = true
            break
          end
        end
        if has_real_win then
          picked_win = wp.pick_window { filter_rules = { include_current_win = true } }
        end
      end
      if picked_win then
        vim.api.nvim_set_current_win(picked_win)
      end
      vim.cmd('edit ' .. vim.fn.fnameescape(filepath))
    end

    require('telescope').setup {
      defaults = require('telescope.themes').get_ivy {
        mappings = {
          i = {
            ['<C-S-k>'] = actions.preview_scrolling_up,
            ['<C-S-j>'] = actions.preview_scrolling_down,
          },
          n = {
            ['<C-S-k>'] = actions.preview_scrolling_up,
            ['<C-S-j>'] = actions.preview_scrolling_down,
            ['s'] = actions.file_vsplit,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          mappings = {
            i = { ['<cr>'] = pick_window_and_open },
            n = { ['<cr>'] = pick_window_and_open },
          },
        },
        lsp_references = {
          initial_mode = 'normal',
        },
        buffers = {
          initial_mode = 'normal',
          sort_mru = true,
          mappings = {
            i = {
              ['<C-d>'] = actions.delete_buffer,
              ['<cr>'] = pick_window_and_open,
            },
            n = {
              ['<C-d>'] = actions.delete_buffer,
              ['<cr>'] = pick_window_and_open,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })

    vim.keymap.set('n', '<F1>', function()
      require('telescope.builtin').commands {
        sort_mru = true,
        prompt_position = 'top',
      }
    end)

    vim.keymap.set('n', 'grv', function()
      require('telescope.builtin').lsp_definitions {
        jump_type = 'vsplit',
      }
    end, { desc = '[G]oto Definition in [V]split (Telescope)' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
