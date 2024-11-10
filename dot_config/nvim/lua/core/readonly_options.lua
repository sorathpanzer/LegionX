vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.swapfile = false
vim.opt.updatetime = 250

vim.opt.number = true
vim.o.relativenumber = false
vim.opt.signcolumn = "yes"
-- vim.opt.numberwidth = 8

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.o.undofile = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Disable mouse mode
vim.o.mouse = ''

vim.opt.clipboard = "unnamedplus"

vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.opt.foldlevel = 99
vim.opt.splitright = true -- Put new windows right of current
vim.opt.spelllang = "pt_pt"
vim.opt.spelllang = "en_us"
vim.opt.spell = false

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 100 }
  end,
})

-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = {'*.conf', 'dunstrc', 'config*', '*.css', '*.toml', '*.nix'},
--   -- group = group,
--   command = 'ColorHighlight'
-- })

require("zen-mode").setup {
  on_open = function(_)
    vim.cmd 'cabbrev <buffer> q let b:quitting = 1 <bar> q'
    vim.cmd 'cabbrev <buffer> wq let b:quitting = 1 <bar> wq'
  end,
  on_close = function()
    if vim.b.quitting == 1 then
      vim.b.quitting = 0
      vim.cmd 'q'
    end
  end,
}
