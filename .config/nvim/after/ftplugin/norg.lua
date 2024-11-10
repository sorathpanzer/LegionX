vim.b.table_mode_corner = "|"
vim.opt.number = false

-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
--   callback = require("zen-mode").open,
--   -- command = 'ZenMode'
-- })
vim.cmd [[highlight @neorg.headings.1.title gui=bold guifg=#ffdab9]]
vim.cmd [[highlight Headline2 gui=bold guibg=#292c41 guifg=#86E1FC]] --21262d
vim.cmd [[highlight @neorg.links.file gui=bold guibg=#292c41 guifg=#86E1FC]] --21262d
vim.cmd [[highlight @neorg.links.file.heading.1 gui=bold guibg=#292c41 guifg=#86E1FC]] --21262d
-- vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
-- vim.cmd [[highlight Dash guibg=#D19A66 gui=bold]]

    require("headlines").setup({
      markdown = {
        -- If set to false, headlines will be a single line and there will be no
        -- "fat_headline_upper_string" and no "fat_headline_lower_string"
        fat_headlines = false,
        --
        -- Lines added above and below the header line makes it look thicker
        -- "lower half block" unicode symbol hex:2584
        -- "upper half block" unicode symbol hex:2580
        fat_headline_upper_string = "▄",
        fat_headline_lower_string = "▀",
        --
        -- You could add a full block if you really like it thick ;)
        -- fat_headline_upper_string = "█",
        -- fat_headline_lower_string = "█",
        --
        -- Other set of lower and upper symbols to try
        -- fat_headline_upper_string = "▃",
        -- fat_headline_lower_string = "-",
        --
        headline_highlights = {
          "Headline1",
          "Headline2",
          "Headline3",
          "Headline4",
          "Headline5",
          "Headline6",
        },

        bullets = { "󰎤", "󰎧", "󰎪", "󰎭", "󰎱", "󰎳" },
      },
    })
