return {
  'mrjones2014/legendary.nvim',
  version = 'v2.13.9',
  -- since legendary.nvim handles all your keymaps/commands,
  -- its recommended to load legendary.nvim before other plugins
  priority = 10000,
  lazy = false,
  -- sqlite is only needed if you want to use frecency sorting
  dependencies = { 'kkharji/sqlite.lua' },
  config = function()
    vim.keymap.set('n', '<F1>', '<cmd>Legendary<cr>', { desc = 'Legendary: Find Commands/Keymaps/Etc' })
  end,
}
