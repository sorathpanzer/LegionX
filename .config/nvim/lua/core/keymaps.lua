vim.keymap.set("i", "<C-c>", "<Esc>")
-- vim.keymap.set("n", "<Enter>", "<Return>") -- Affect Neorg open links

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-l>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<C-;>", "<cmd>lprev<CR>zz")

vim.keymap.set({ "i", "s" }, "<C-j>", function() vim.snippet.jump(1) end)
vim.keymap.set({ "i", "s" }, "<C-k>", function() vim.snippet.jump(-1) end)

vim.keymap.set({ "n", "v" }, "x", "\"_x")
vim.keymap.set({ "n", "v" }, "X", "\"_X")
vim.keymap.set({ "n", "v" }, "c", "\"_c")
vim.keymap.set({ "n", "v" }, "C", "\"_C")

vim.g.mapleader = " "

vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set({ "n", "v" }, "<leader>y", "\"+y")
vim.keymap.set({ "n", "v" }, "<leader>p", "\"+p")
vim.keymap.set({ "n", "v" }, "<leader>P", "\"+P")

-- vim.keymap.set("n", "<leader>z", "mzgg\"+yG`z")
-- vim.keymap.set("n", "<leader>x", "gg\"_dG")
vim.keymap.set('n', '<leader>x', ':bnext<CR>', silent)
vim.keymap.set('n', '<leader>z', ':bprevious<CR>', silent)
vim.keymap.set('n', '<leader>c', ':bp<CR>:bd#<CR>', silent)
vim.keymap.set("n", "<leader>q", vim.cmd.Ex)

vim.keymap.set("n", "<leader>t", ":TransparentToggle<CR>", silent)
vim.keymap.set("n", "<leader>f", ":Texplore<CR>", silent)
vim.keymap.set("n", "<leader>b", ":Telescope buffers<CR>", silent)

vim.api.nvim_set_keymap("n", "++", "gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "++", "gcc", { noremap = false })
vim.api.nvim_set_keymap("n", "x", "V", { noremap = false })
vim.api.nvim_set_keymap("v", "x", "j", { noremap = false })
vim.api.nvim_set_keymap("n", "Y", "ggVGy", { noremap = false })
vim.api.nvim_set_keymap("n", "<leader>v", "ggVG", { noremap = false })

vim.keymap.set('n', '<C-s>', function ()
  require('leap').leap {
    target_windows = require('leap.user').get_focusable_windows()
  }
end)
