vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "catppuccin",
    callback = function()
        local transparent_groups = {
            "Normal",
            "NormalFloat",
            "SignColumn",
            "LineNr",
            "EndOfBuffer",
        }
        for _, group in ipairs(transparent_groups) do
            local existing = vim.api.nvim_get_hl(0, { name = group })
            existing.bg = nil
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_set_hl(0, group, existing)
        end
    end,
})

vim.cmd.colorscheme("catppuccin")
