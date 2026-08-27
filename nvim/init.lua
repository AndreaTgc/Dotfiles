vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true

vim.opt.undofile = false 
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

vim.cmd("colorscheme catppuccin")

-- Plugins config
vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pick").setup()

-- Key bindings
vim.keymap.set("n", "<leader>ff", function() vim.cmd("Pick files") end, { desc = "file picker" })
vim.keymap.set("n", "<leader>fg", function() vim.cmd("Pick grep") end, { desc = "Buffers grep" })
