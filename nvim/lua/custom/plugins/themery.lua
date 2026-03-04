return {
  'zaldih/themery.nvim',
  lazy = false,
  config = function()
    require('themery').setup {
      livePreview = true,
      -- add the config here
    }
  end,
}
