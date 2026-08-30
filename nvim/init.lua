require "config.opts"
require "config.lsp"
require "config.theme"

vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" }
})

require("mini.icons").setup()
require("mini.statusline").setup()
require("mini.pick").setup()
require("oil").setup()

-- Key bindings
vim.keymap.set("n", "<leader>ff", function() vim.cmd("Pick files") end, { desc = "file picker" })
vim.keymap.set("n", "<leader>fg", function() vim.cmd("Pick grep") end, { desc = "Buffers grep" })
vim.keymap.set("n", "-", function () vim.cmd("Oil") end)
