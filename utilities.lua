local awful = require("awful")
local naughty = require("naughty")
local beautiful = require("beautiful")

utilities = {}

-- Run a program once
function utilities.run_once(prg, arg_string, pname, s, tag)
    if not prg then
        do return nil end
    end

    if not pname then
       pname = prg
    end

    if not arg_string then
       cmd_pgrep = pname
       cmd_exe = prg
    else
       cmd_pgrep = pname .. " " .. arg_string
       cmd_exe = prg .. " " .. arg_string
    end
    cmd = "pgrep -f -u $USER -x '" .. cmd_pgrep .. "' || (" .. cmd_exe .. ")"
    if s and tag then
       local pid = io.popen("pgrep -f -x '" .. cmd_pgrep .. "'"):read("*all")
       if pid == "" then
          awful.spawn(cmd_exe, { tag = screen[s].tags[tag] })
       end
    else
       awful.spawn.with_shell(cmd)
    end
end

-- Simple notification
function utilities.notify_me(title,txt)
    naughty.notify({
        icon = "/usr/share/icons/Adwaita/32x32/apps/preferences-desktop-accessibility.png",
        title = title,
	text = txt,
        timeout = 2,
        hover_timeout = 0.5
    })
end

return utilities
