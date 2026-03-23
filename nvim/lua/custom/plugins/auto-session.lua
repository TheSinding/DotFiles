return {
  'rmagatti/auto-session',
  lazy = false,

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
    -- log_level = 'debug',
    session_lens = {
      picker = 'telescope',
      load_on_setup = true,
    },
  },
  keys = {
    { '<leader>sa', '<cmd>AutoSession search<cr>', desc = 'Search sessions[a]' },
  },
}
