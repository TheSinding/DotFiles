local M = {}

M.base46 = {
  theme = 'onedark',
  transparency = false,
}

M.ui = {
  tabufline = { enabled = true },
  statusline = {
    theme = 'default',
    separator_style = 'round',
    -- See :help nvui
    -- order = { "mode", "my_module"},
    modules = {
      my_module = function()
        return 'hi'
      end,
    },
  },
}

return M
