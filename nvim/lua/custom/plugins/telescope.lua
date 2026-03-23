local actions = require 'telescope.actions'

vim.keymap.set('n', '/', function()
  require('telescope.builtin').current_buffer_fuzzy_find()
end)

vim.keymap.set('n', '<F1>', function()
  require('telescope.builtin').commands()
end)

require('telescope').setup {
  defaults = require('telescope.themes').get_ivy {
    mappings = {
      i = {
        ['<S-k>'] = actions.preview_scrolling_up,
        ['<S-j>'] = actions.preview_scrolling_down,
      },
      n = {
        ['<S-k>'] = actions.preview_scrolling_up,
        ['<S-j>'] = actions.preview_scrolling_down,
      },
    },
  },
  pickers = {
    buffers = {
      initial_mode = 'normal',
      mappings = {
        i = { ['<C-d>'] = actions.delete_buffer },
        n = { ['<C-d>'] = actions.delete_buffer },
      },
    },
  },
}

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

return {}
