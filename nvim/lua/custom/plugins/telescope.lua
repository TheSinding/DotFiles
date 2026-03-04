vim.api.nvim_create_autocmd('User', {
  pattern = 'TelescopeSetup',
  callback = function()
    local actions = require 'telescope.actions'
    require('telescope').setup {
      pickers = {
        buffers = {
          mappings = {
            i = { ['<C-d>'] = actions.delete_buffer },
            n = { ['<C-d>'] = actions.delete_buffer },
          },
        },
      },
    }
  end,
})

return {}
