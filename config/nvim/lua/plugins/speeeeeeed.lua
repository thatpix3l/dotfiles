return {
    "ggandor/leap.nvim",
    config = function()
        local leap = require("leap")
        leap.add_default_mappings()
        require("autocommands").apply({
            {
                mode = "ColorScheme",
                opts = {
                    callback = function()
                        leap.init_highlight(true)
                    end
                }
            }
        })
    end
}
