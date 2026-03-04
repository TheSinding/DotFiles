return {
  -- Calls `require('slimline').setup({})`
  --
  'sschleemilch/slimline.nvim',
  lazy = false,
  priority = 900,
  opts = {
    spaces = {
      components = '─',
      left = '─',
      right = '─',
    },
    path = {
      hl = {
        primary = 'Define',
      },
    },
    git = {
      hl = {
        primary = 'Function',
      },
    },
    filetype_lsp = {
      hl = {
        primary = 'String',
      },
    },
  },
}
