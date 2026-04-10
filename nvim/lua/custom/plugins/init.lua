-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Handle LSP hover on CursorHold
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.hoverProvider then
      local group = vim.api.nvim_create_augroup('lsp_hover_' .. bufnr, { clear = true })

      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = bufnr,
        group = group,
        callback = function()
          -- Only show hover in normal mode and when completion menu isn't open
          local mode = vim.api.nvim_get_mode().mode
          if mode ~= 'n' then
            return
          end
          local ok, blink = pcall(require, 'blink.cmp')
          if ok and blink.is_visible() then
            return
          end
          vim.lsp.buf.hover()
        end,
      })
    end
  end,
})

-- Move lines up/down in normal mode
vim.keymap.set('n', '<C-S-K>', ':m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('n', '<C-S-J>', ':m .+1<CR>==', { desc = 'Move line down' })

-- Move lines up/down in visual mode
vim.keymap.set('v', '<C-S-J>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<C-S-K>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Pageup and pagedown with j and k
vim.keymap.set('n', 'J', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('n', 'K', '<C-u>zz', { desc = 'Page up and center' })

vim.keymap.set('v', 'J', '<C-d>zz', { desc = 'Page down and center' })
vim.keymap.set('v', 'K', '<C-u>zz', { desc = 'Page up and center' })

vim.keymap.set('n', '<leader>J', 'J', { desc = 'Join lines' }) -- Move join to leader
vim.keymap.set('n', '<leader>K', vim.lsp.buf.hover, { desc = 'LSP hover' }) -- Move hover to leader

vim.o.updatetime = 500 -- Show after 500ms of no movement
return {}
