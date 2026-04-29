-- My misc plugins
return {
  {
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
  },
  { 'mrjones2014/op.nvim', build = 'make install' },
  {
    'renerocksai/telekasten.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim', 'mattn/calendar-vim' },
    config = function()
      require('telekasten').setup {
        home = vim.fn.expand '~/notes',
        dailies = 'daily',
        weeklies = 'weekly',
        templates = 'templates',
        template_new_daily = vim.fn.expand '~/notes/templates/daily.md',
      }
      -- Launch panel if nothing is typed after <leader>z
      vim.keymap.set('n', '<leader>z', '<cmd>Telekasten panel<CR>')

      -- Most used functions
      vim.keymap.set('n', '<leader>zf', '<cmd>Telekasten find_notes<CR>')
      vim.keymap.set('n', '<leader>zg', '<cmd>Telekasten search_notes<CR>')
      vim.keymap.set('n', '<leader>zd', '<cmd>Telekasten goto_today<CR>')
      vim.keymap.set('n', '<leader>zz', '<cmd>Telekasten follow_link<CR>')
      vim.keymap.set('n', '<leader>zn', '<cmd>Telekasten new_note<CR>')
      vim.keymap.set('n', '<leader>zc', '<cmd>Telekasten show_calendar<CR>')
      vim.keymap.set('n', '<leader>zb', '<cmd>Telekasten show_backlinks<CR>')
      vim.keymap.set('n', '<leader>zI', '<cmd>Telekasten insert_img_link<CR>')

      -- Call insert link automatically when we start typing a link
      vim.keymap.set('i', '[[', '<cmd>Telekasten insert_link<CR>')
    end,
  },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    'kndndrj/nvim-dbee',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters:
      --    "curl", "wget", "bitsadmin", "go"
      require('dbee').install()
    end,
    config = function()
      require('dbee').setup(--[[optional config]])
    end,
  },
  {
    'ribelo/taskwarrior.nvim',
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    'DerTimonius/twkb.nvim',
    config = function()
      require('twkb').setup()
    end,
  },
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*', -- use latest release, remove to use latest commit
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false, -- this will be removed in 4.0.0
      workspaces = {
        {
          name = 'personal',
          path = '~/code/notes/ttl',
        },
        {
          name = 'work',
          path = '~/code/notes/work',
        },
      },
    },
  },
}
