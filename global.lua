
local global = {
    terminal = "st",
    theme = "algae",
    editor = os.getenv("EDITOR") or "nvim",
    modkey = "Mod4"
}

global.editor_cmd = global.terminal .. " -e " .. global.editor

return global
