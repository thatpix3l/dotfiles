local wezterm = require("wezterm")

-- Config table
local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end

-- Set window directions to be integrated, for more immersive experience
config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"

-- Get details of a given color scheme
local color_scheme = {}
color_scheme.name = "ayu"
color_scheme.config = wezterm.color.get_builtin_schemes()[color_scheme.name]

-- Apply color scheme
config.color_scheme = color_scheme.name

-- Make titlebar background match theme's color background
config.window_frame = {
    active_titlebar_bg = color_scheme.config.background
}

config.colors = {
    tab_bar = {
        -- Tab separator is transparent
        inactive_tab_edge = "rgba(0,0,0,0)",

        -- "New Tab" button follows scheme
        new_tab = {
            bg_color = color_scheme.config.background,
            fg_color = color_scheme.config.foreground
        }
    }

}

-- Tab edges for rounded tabs
local tab_edge = {
    left = "",
    right = ""
}

-- Different ways to format tab colors
local tabFmt = {}

-- Make tabs look like they're floating, based off of color scheme
tabFmt.floating = function(tab, tabs, panes, config, hover, max_width)
    -- Colors for active tab
    local color = {}
    color[1] = color_scheme.config.background
    color[2] = color_scheme.config.foreground

    -- Swap colors if tab is inactive
    if tab.is_active then
        color[1] = color_scheme.config.foreground
        color[2] = color_scheme.config.background
    end

    return {
        -- Left tab edge
        { Background = { Color = color_scheme.config.background } },
        { Foreground = { Color = color[1] } },
        { Text = tab_edge.left },

        -- Tab text
        { Background = { Color = color[1] } },
        { Foreground = { Color = color[2] } },
        { Text = tab.active_pane.title },

        -- Right tab edge
        { Background = { Color = color_scheme.config.background } },
        { Foreground = { Color = color[1] } },
        { Text = tab_edge.right },
    }
end

wezterm.on(
    "format-tab-title",
    tabFmt.floating
)

return config
