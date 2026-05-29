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
      lsp_clients = function()
        local clients = vim.lsp.get_clients { bufnr = 0 }
        if #clients == 0 then
          return ''
        end
        local names = {}
        for _, client in ipairs(clients) do
          if client.name == 'typos_lsp' then
            goto continue
          end
          table.insert(names, client.name)
          ::continue::
        end
        return '%#St_LspStatus#' .. ' ' .. table.concat(names, ', ') .. ' '
      end,
    },
    order = { 'mode', 'file', 'git', '%=', 'lsp_msg', 'diagnostics', 'lsp_clients', 'cursor', 'cwd' },
  },
}

return M
