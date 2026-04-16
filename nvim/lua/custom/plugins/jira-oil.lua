return {
  dir = '~/code/jira-oil.nvim',
  keys = {
    {
      '<leader>jj',
      function()
        require('jira-oil').open 'all'
      end,
      desc = 'JiraOil: all',
    },
    {
      '<leader>js',
      function()
        require('jira-oil').open 'sprint'
      end,
      desc = 'JiraOil: sprint',
    },
    {
      '<leader>jc',
      function()
        require('jira-oil.scratch').open_new()
      end,
      desc = 'JiraOil: create issue',
    },
  },
  config = function()
    require('jira-oil').setup {
      cli = {
        defaults = {
          project = 'ASM', -- or set JIRA_PROJECT env var
        },
        issues = {
          columns = { 'key', 'assignee', 'status', 'summary', 'labels', 'type', 'parent' },
          -- team_jql = '', -- e.g. "assignee in membersOf('TEAM_JQL')"
          -- exclude_jql = 'issuetype != Epic',
          status_jql = 'status NOT IN ("Done", "Cancelled", "Closed")',
        },
      },
      view = {
        group_subtasks = true,
        columns = {
          { name = 'status', width = 15 },
          { name = 'type', width = 15 },
          { name = 'assignee', width = 15 },
          { name = 'summary', width = 55 },
          { name = 'labels' },
        },
      },
    }
  end,
}
