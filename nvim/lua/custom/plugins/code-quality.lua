return {
  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters = {
        prettier = {
          condition = function(self, ctx)
            return not vim.fs.root(ctx.buf, { 'biome.json', 'biome.jsonc' })
          end,
        },
      },
      formatters_by_ft = {
        lua = { 'stylua' },
        typescript = { 'biome', 'biome-organize-imports', 'prettier' },
        typescriptreact = { 'biome', 'biome-organize-imports', 'prettier' },
        javascript = { 'biome', 'biome-organize-imports', 'prettier' },
        javascriptreact = { 'biome', 'biome-organize-imports', 'prettier' },
      },
    },
  },

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
      }

      -- Point markdownlint at the global config in $HOME.
      -- markdownlint-cli does not auto-discover ~/.markdownlint.yaml,
      -- and nvim-lint pipes via --stdin (no file path to walk up from),
      -- so pass --config explicitly.
      local markdownlint = lint.linters.markdownlint
      table.insert(markdownlint.args, '--config')
      table.insert(markdownlint.args, vim.fn.expand '~/.markdownlint.yaml')

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
