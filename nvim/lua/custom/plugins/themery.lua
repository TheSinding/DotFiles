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
      },
      -- add the config here
    }
  end,
}
