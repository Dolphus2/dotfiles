-- Personal keybinding overrides from dotfiles.
-- Keep only your personal keybinding overrides here. Add new bindings with
-- o.bind or replace defaults with o.rebind.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding. o.rebind takes the same arguments as o.bind.
-- This example replaces the default file manager with Flea.
-- o.rebind("SUPER + SHIFT + F", "File manager", { launch = "flea" })

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, { panel = "omarchy.emojis" })


-- Start of my personal keybinding overrides.

-- Omit the default binding for closing the active window.
-- hl.unbind("SUPER + Q")

hl.unbind("SUPER + SHIFT + G") -- unbind signal
hl.unbind("SUPER + SHIFT + ALT + A")
hl.unbind("SUPER + SHIFT + CTRL + G")
hl.unbind("SUPER + SHIFT + P")
hl.unbind("SUPER + SHIFT + X")
hl.unbind("SUPER + SHIFT + ALT + X")

o.rebind("SUPER + SHIFT + C", "Calendar", { webapp = "https://calendar.google.com" })

o.rebind("SUPER + SHIFT + A", "Claude", { webapp = "https://claude.ai" })

o.rebind("SUPER + SHIFT + E", "Gmail", { webapp = "https://mail.google.com" })

-- o.rebind("SUPER + SHIFT + S", "Screenshot with editing", "omarchy-capture-screenshot --editor")

o.bind("SUPER + SHIFT + Z", "Swap monitor workspaces", function()
  hl.dispatch(hl.dsp.workspace.swap_monitors({ monitor1 = "DP-1", monitor2 = "HDMI-A-2" }))
end)
