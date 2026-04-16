return {
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
      -- add the config here
    }
  end,
}
