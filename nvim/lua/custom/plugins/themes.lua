--[=[ THEMES DISABLED -- using nvchad/base46 instead
return {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'projekt0n/github-nvim-theme' },
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
      require('gruvbox').setup {}
    end,
  },
  {
    'Zeioth/neon.nvim',
    opts = {
      dim_inactive = false,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
      },
    },
  },
  { 'EdenEast/nightfox.nvim' },
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },
  {
    'zaldih/themery.nvim',
    lazy = false,
    config = function()
      require('themery').setup {
        livePreview = true,
        themes = {
          { name = 'Nightfox', colorscheme = 'nightfox' },
          { name = 'Dayfox', colorscheme = 'dayfox' },
          { name = 'Gruvbox Dark', colorscheme = 'gruvbox', before = [[vim.opt.background = "dark"]] },
          { name = 'Gruvbox Light', colorscheme = 'gruvbox', before = [[vim.opt.background = "light"]] },
          { name = 'Tokyo Night Moon', colorscheme = 'tokyonight-moon' },
          { name = 'GitHub Dark', colorscheme = 'github_dark' },
          { name = 'GitHub Light', colorscheme = 'github_light' },
          { name = 'Catppuccin Latte', colorscheme = 'catppuccin-latte' },
          { name = 'Catppuccin Frappe', colorscheme = 'catppuccin-frappe' },
          { name = 'Catppuccin Macciato', colorscheme = 'catppuccin-macchiato' },
          { name = 'Catppuccin Mocha', colorscheme = 'catppuccin-mocha' },
          { name = 'Neon - Cherrykiss Night', colorscheme = 'neon-cherrykiss-night' },
          { name = 'Neon - Cyberpunk Night', colorscheme = 'neon-cyberpunk-night' },
          { name = 'Neon - Netrunner Night', colorscheme = 'neon-netrunner-night' },
          { name = 'Neon - Punkpeach Night', colorscheme = 'neon-punkpeach-night' },
          { name = 'Neon - Cherrykiss Storm', colorscheme = 'neon-cherrykiss-storm' },
          { name = 'Neon - Cyberpunk  Storm', colorscheme = 'neon-cyberpunk-storm' },
          { name = 'Neon - Netrunner Storm', colorscheme = 'neon-netrunner-storm' },
          { name = 'Neon - Punkpeach Storm', colorscheme = 'neon-punkpeach-storm' },
        },
      }
    end,
  },
}
]=]

return {}
