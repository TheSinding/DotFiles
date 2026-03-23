-- Using Snacks.lazygit instead of kdheepak/lazygit.nvim because Snacks
-- sets up the $NVIM server socket so pressing `e` in lazygit opens the file
-- in the existing Neovim instance rather than spawning a nested nvim.
return {
  'folke/snacks.nvim',
  opts = {
    lazygit = { enabled = true },
  },
  keys = {
    { '<leader>ll', function() Snacks.lazygit() end,          desc = 'Lazygit' },
    { '<leader>lf', function() Snacks.lazygit.log_file() end, desc = 'Lazygit log (current file)' },
    { '<leader>lg', function() Snacks.lazygit.log() end,      desc = 'Lazygit log (repo)' },
  },
}
