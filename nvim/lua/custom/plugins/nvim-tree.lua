return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true

    require('nvim-tree').setup {
      view = { adaptive_size = true },
      on_attach = function(bufnr)
        local api = require 'nvim-tree.api'

        -- First load all default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Then override the cd mapping
        vim.keymap.set('n', '<C-o>', api.tree.change_root_to_node, {
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
          desc = 'nvim-tree: CD',
        })
      end,
    }
  end,
}
