return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()

        -- Hide command line
        vim.opt.cmdheight = 0

        -- Escape a string containing lua special characters
        local function literalize(str)
            return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
        end

        -- Create a "pretty" current working directory string
        local function cwd()
            return vim.fn.getcwd():gsub(literalize(os.getenv("HOME") or ""), "~")
        end

        require("lualine").setup {
            sections = {
                lualine_c = { cwd, "filename" },
                lualine_x = { "searchcount" },
                lualine_y = { "filetype" },
                lualine_z = { "progress" }
            }
        }

    end
}
