-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      { 's1n7ax/nvim-window-picker', version = '2.*' },
    },
    lazy = false,
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
      { '<C-w>b', ':Neotree reveal<CR>', desc = 'NeoTree reveal' },
    },
    opts = {
      buffers = {
        follow_current_file = true,
      },
      filesystem = {
        hijack_netrw_behavior = 'disabled',
        follow_current_file = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            'node_modules',
          },
          never_show = {
            '.DS_Store',
            'thumbs.db',
          },
        },
      },
      window = {
        position = 'right',
        mappings = {
          ['\\'] = 'close_window',
          ['<cr>'] = 'open_with_window_picker',
        },
      },
    },
  },
  {
    's1n7ax/nvim-window-picker',
    version = '2.*',
    config = function()
      require('window-picker').setup {
        hint = 'floating-big-letter',
        filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options

          bo = {
            -- if the file type is one of following, the window will be ignored
            filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
            -- if the buffer type is one of following, the window will be ignored
            buftype = { 'terminal', 'quickfix' },
          },
        },
      }
    end,
  },
}
