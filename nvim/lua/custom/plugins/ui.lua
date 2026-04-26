return {
  -- -- Replaces cmdline, messages, and notifications with a polished UI
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      routes = {
        {
          filter = {
            event = 'notify',
            find = 'No information available',
          },
          opts = { skip = true },
        },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
  },

  { 'rcarriga/nvim-notify', opts = {
    top_down = false,
    render = 'compact',
  } },
  --
  -- -- Startup dashboard
  -- {
  --   'nvimdev/dashboard-nvim',
  --   event = 'VimEnter',
  --   config = function()
  --     require('dashboard').setup {}
  --   end,
  --   dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- },
  --
  -- -- Statusline
  -- {
  --   'sschleemilch/slimline.nvim',
  --   lazy = false,
  --   priority = 900,
  --   opts = {
  --     spaces = {
  --       components = '─',
  --       left = '─',
  --       right = '─',
  --     },
  --     path = {
  --       hl = { primary = 'Define' },
  --     },
  --     git = {
  --       hl = { primary = 'Function' },
  --     },
  --     filetype_lsp = {
  --       hl = { primary = 'String' },
  --     },
  --   },
  -- },
  --
  -- -- Indent guide lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  --
  -- Animated cursor trail
  {
    'sphamba/smear-cursor.nvim',
    opts = {},
  },

  -- NvChad theming engine — compiles highlight groups to a cache
  {
    'nvchad/base46',
    lazy = true,
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  -- NvChad UI: tabufline (bufferline) and statusline
  {
    'nvchad/ui',
    lazy = false,
    config = function()
      require 'nvchad'
      vim.keymap.set('n', '<leader>tg', require('nvchad.themes').open, { desc = 'Open themes picker' })
    end,
  },
  {
    'nvchad/volt', -- optional, needed for theme switcher
  },
}
