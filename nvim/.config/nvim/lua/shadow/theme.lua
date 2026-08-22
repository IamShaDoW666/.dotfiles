-- Universal theming for neovim

local default_theme = "base16-gruvbox-dark-hard"

local function get_tinty_theme()
    local theme_name = vim.fn.system("MISE_QUIET=1 tinty current 2>/dev/null")
    theme_name = vim.trim(theme_name)

    if vim.v.shell_error ~= 0 or theme_name == "" then
        return default_theme
    else
        local lines = vim.split(theme_name, "\n", { trimempty = true })
        return lines[#lines] or default_theme
    end
end

local function main()
    vim.o.termguicolors = true
    vim.g.tinted_colorspace = 256
    local current_theme_name = get_tinty_theme()

    if current_theme_name == "base16-vague" then
        current_theme_name = "vague"
    end

    vim.cmd("colorscheme " .. current_theme_name)
    require("shadow.transparency").setup()
end

main()
