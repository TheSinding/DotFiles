-- [[ Custom Keymaps ]]
-- General keymaps not tied to any specific plugin.

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Open diagnostic quickfix list
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Disable the macro stuff - Hate accidentailly opening the window
vim.keymap.set('n', 'q', '<Nop>')

-- Smart H/L (NvME style): expr=true returns key strings so they compose with
-- operators (dH, yL, etc.) and counts, and skip block-jump during macros.
local function smart_H()
  if vim.fn.reg_recording() ~= '' then
    return '^'
  end

  local col = vim.fn.col '.'
  local first_nonblank = vim.fn.match(vim.fn.getline '.', [[\S]]) + 1
  if col == first_nonblank or col == 1 then
    return '{'
  end
  return '^'
end

local function smart_L()
  if vim.fn.reg_recording() ~= '' then
    return '$'
  end
  local col = vim.fn.col '.'
  local line = vim.fn.getline '.'
  if col >= #line then
    return '}'
  end
  return '$'
end

vim.keymap.set({ 'n', 'v' }, 'H', smart_H, { expr = true, desc = 'Smart H (^ or {)' })
vim.keymap.set({ 'n', 'v' }, 'L', smart_L, { expr = true, desc = 'Smart L ($ or })' })
