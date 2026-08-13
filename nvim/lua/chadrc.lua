local M = {}

-- NvChad's own signature autocmd fires vim.lsp.buf.signature_help on every
-- keystroke near '('/',' — but noice.nvim replaces that function, and noice
-- treats such calls as user-invoked: if the panel is already open it focuses
-- it (nvim_set_current_win + stopinsert), yanking the cursor into the float
-- mid-typing. Noice has its own safe auto-open, so disable NvChad's.
M.lsp = { signature = false }

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
