return {
  'letieu/jira.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'folke/snacks.nvim',
    'mrjones2014/op.nvim',
  },
  config = function()
    local jiraTokenOPItemName = 'jira-token'
    local opApi = require 'op.api'

    -- Get credentials synchronously
    local result, err = opApi.item.get {
      jiraTokenOPItemName,
      '--fields',
      'password,username,project,apiurl',
      '--reveal',
      '--format',
      'json',
    }

    if err[1] then
      vim.notify(string.format('Failed to get %s from 1Password', jiraTokenOPItemName), vim.log.levels.ERROR)
      return
    end

    local ok, records = pcall(vim.json.decode, table.concat(result))
    if not ok then
      vim.notify('Failed to parse 1Password JSON', vim.log.levels.ERROR)
      return
    end

    local passwordRecord = records[1]
    local usernameRecord = records[2]
    local projectRecord = records[3]
    local apiUrlRecord = records[4]

    -- Save credentials to the auth file that jira.nvim actually uses
    local auth = require 'jira.common.auth'
    auth.save {
      base = apiUrlRecord['value'],
      email = usernameRecord['value'],
      token = passwordRecord['value'],
      type = 'basic',
    }

    -- Setup jira.nvim with project config
    require('jira').setup {
      active_sprint_query = "(reporter = currentUser() OR assignee = currentUser() OR labels in (Milkyway, Assortment)) AND status != 'Done' AND issuetype in (Bug, Sub-task, Task) ORDER BY Rank ASC",
      projects = {
        [projectRecord['value']] = {},
      },
      queries = {
        ['My Work'] = "(reporter = currentUser() OR assignee = currentUser() OR labels in (Milkyway, Assortment)) AND status != 'Done' AND issuetype in (Bug, Sub-task, Task) ORDER BY Rank ASC",
      },
    }
  end,
}
