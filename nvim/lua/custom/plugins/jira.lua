return {
  'letieu/jira.nvim',
  opts = {
    -- Your setup options...
    jira = {
      base = 'https://your-domain.atlassian.net', -- Base URL of your Jira instance
      email = 'your-email@example.com', -- Your Jira email (Optional for PAT)
      token = 'your-api-token', -- Your Jira API token or PAT
      type = 'basic', -- Authentication type: "basic" (default) or "pat"
      limit = 200, -- Global limit of tasks per view (default: 200)
    },
  },
}
