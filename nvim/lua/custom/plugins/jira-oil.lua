return {
  'sbulav/jira-oil.nvim',
  config = function()
    require('jira-oil').setup {
      defaults = {
        project = 'ASM', -- or set JIRA_PROJECT env var
      },
    }
  end,
}
