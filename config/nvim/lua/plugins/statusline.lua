-- Escape a string containing lua special characters
local literalize = function(str)
    return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
end

-- Create a "pretty" current working directory string
local function cwd()
    return vim.fn.getcwd():gsub(literalize(os.getenv("HOME") or ""), "~")
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup {
            sections = {
                lualine_c = { cwd, "filename" },
                lualine_x = { "searchcount" },
                lualine_y = { "filetype" },
                lualine_z = { "progress" }
            },
            options = {
                component_separators = {
                    right = '',
                    left = ''
                },
                section_separators = {
                    right = '',
                    left = ''
                }
            }
        }
    end
}
