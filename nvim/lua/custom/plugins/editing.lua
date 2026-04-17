return {
  -- Surround text objects with brackets, quotes, tags, etc.
  {
    'kylechui/nvim-surround',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-treesitter/nvim-treesitter-textobjects' },
    event = 'VeryLazy',
    opts = {},
  },

  -- -- Auto-close and rename HTML/JSX tags
  -- {
  --   'windwp/nvim-ts-autotag',
  --   opts = {
  --     opts = {
  --       enable_close = true,
  --       enable_rename = true,
  --       enable_close_on_slash = false,
  --     },
  --   },
  -- },
  --
  -- -- Auto-close brackets/parens/quotes
  -- { 'windwp/nvim-autopairs' },
  -- {
  --   'm4xshen/autoclose.nvim',
  --   config = function()
  --     require('autoclose').setup()
  --   end,
  -- },
}
