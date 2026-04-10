return {
  'letieu/jira.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'folke/snacks.nvim',
    'mrjones2014/op.nvim',
  },
  lazy = true,
  config = function()
    local auth = require 'jira.common.auth'
    local projectRecord = 'ASM'

    local localToken = auth.load()

    if localToken == nil then
      local jiraTokenOPItemName = 'jira-token'
      local opApi = require 'op.api'
      local projectRecord = 'ASM'

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
      local apiUrlRecord = records[4]

      -- Save credentials to the auth file that jira.nvim actually uses
      auth.save {
        base = apiUrlRecord['value'],
        email = usernameRecord['value'],
        token = passwordRecord['value'],
        type = 'basic',
      }
    end

    -- Setup jira.nvim with project config
    require('jira').setup {
      -- jira = {

      active_sprint_query = "(reporter = currentUser() OR assignee = currentUser() OR labels in (Milkyway, Assortment)) AND status != 'Done' AND issuetype in (Bug, Sub-task, Task) ORDER BY Rank ASC",
      projects = {
        [projectRecord] = {},
      },
      queries = {
        ['My Work'] = "(reporter = currentUser() OR assignee = currentUser() OR labels in (Milkyway, Assortment)) AND status != 'Done' AND issuetype in (Bug, Sub-task, Task) ORDER BY Rank ASC",
      },
      -- },
    }
  end,
}
