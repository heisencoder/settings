-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/configuring/
--
-- Matt's config: modeled on ~/settings/i3/config, for Hyprland 0.57 (Lua config).
-- Ported from the hyprlang hyprland.conf, which Hyprland 0.57 no longer reads.
-- All window-manager bindings use mainMod (Super) or mainMod+Ctrl with right-hand keys.
--
-- Install these packages to fully enable this file:
-- sudo apt install hyprland xdg-desktop-portal-hyprland hyprlock hypridle hyprpolkitagent \
--   waybar fuzzel mako-notifier libnotify-bin grim slurp wl-clipboard brightnessctl \
--   playerctl gammastep jq blueman fonts-font-awesome gir1.2-playerctl-2.0 pavucontrol \
--   hyprland-qtutils socat ddcutil network-manager-applet

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/configuring/core/monitors/
-- hl.monitor({
--     output   = "",
--     mode     = "preferred",
--     position = "auto",
--     scale    = "auto",
-- })
-- Fixed 1x scale; adjust font sizes per app instead.  "auto" picked 2x,
-- which made everything far too large.
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
-- local terminal    = "kitty"
-- local fileManager = "dolphin"
-- local menu        = "hyprlauncher"
-- Terminal preference: Ghostty, kitty, Alacritty, then Ubuntu's default (Ptyxis).
local terminal    = "/snap/bin/ghostty || kitty || alacritty || xdg-terminal-exec"
local fileManager = "nautilus"
local menu        = "fuzzel"
local browser     = "/usr/bin/google-chrome-stable --enable-features=NativeNotifications --disable-features=CustomizeChromeSidePanel"
local scripts     = "~/.config/hypr/scripts"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/configuring/core/autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function ()
--   hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
--   hl.exec_cmd("waybar & hyprpaper & firefox")
    -- As a systemd service, so that it restarts if it crashes, and stopping or
    -- restarting it (including at logout) also stops its module scripts.
    -- Started rather than enabled, so that it only runs in Hyprland.
    hl.exec_cmd("systemctl --user start waybar")
    -- hl.exec_cmd("mako") -- Don't start this separately; it's already started by systemd when installing mako-notifier
    -- hl.exec_cmd("hypridle") -- Don't start this separately; it's already started by systemd when installing hypridle
    -- Undo a fade before the lock that was never restored (see hypridle.conf).
    hl.exec_cmd(scripts .. "/dim.sh restore")
    hl.exec_cmd("blueman-applet")
    -- hl.exec_cmd("systemctl --user start hyprpolkitagent") -- Already started by systemd when installing hyprpolkitagent
    -- Laptop screen off while an external monitor is connected (also on hotplug).
    hl.exec_cmd(scripts .. "/monitors.sh watch")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/

-- hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")
-- 1.25x the default, to match the 1x display scale (see MONITORS).
hl.env("XCURSOR_SIZE", "30")
hl.env("HYPRCURSOR_SIZE", "30")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/
hl.config({
    general = {
        -- gaps_in  = 5,
        -- gaps_out = 20,
        -- Windows reach the very edge of the screen (gaps_out = 0, no border), so a
        -- click on the edge goes straight into the window (Fitts' law).  Between
        -- windows, gaps_in leaves an 8px separator (4px per window) that shows
        -- misc.background_color.  Hyprland borders are the same width on all four
        -- sides, so a thick border between windows would also cover the screen edge.
        gaps_in  = 4,
        gaps_out = 0,

        -- border_size = 2,
        -- The focused window is the one that isn't dimmed (see dim_inactive below).
        border_size = 0,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        -- resize_on_border = false,
        -- Drag the gap between two windows to resize them.
        resize_on_border = true,

        -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
        allow_tearing = false,

        -- layout = "dwindle",
        -- Master layout: main windows across the top, small windows in a row below.
        layout = "master",
    },

    decoration = {
        -- rounding       = 10,
        rounding       = 0,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        -- Dim unfocused windows, like `picom --inactive-dim 0.125` under i3.
        dim_inactive = true,
        dim_strength = 0.125,

        shadow = {
            -- enabled      = true,
            enabled      = false,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            -- enabled   = true,
            enabled   = false,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/configuring/core/animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
-- hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, damping = 24.21279333 })

-- Zippy: each speed is 30% of the old hyprlang default (speed is a duration, so 3x faster).
-- The windows animations keep the old easeOutQuint curve rather than the new "easy" spring.
-- hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "global",        enabled = true,  speed = 3,    bezier = "default" })
-- hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "border",        enabled = true,  speed = 1.62, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 1.44, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 1.23, bezier = "easeOutQuint", style = "popin 87%" })
-- hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 0.45, bezier = "linear",       style = "popin 87%" })
-- hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 0.52, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 0.44, bezier = "almostLinear" })
-- hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 0.91, bezier = "quick" })
-- hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 1.14, bezier = "easeOutQuint" })
-- hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 1.2,  bezier = "easeOutQuint", style = "fade" })
-- hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 0.45, bezier = "linear",       style = "fade" })
-- hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 0.54, bezier = "almostLinear" })
-- hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 0.42, bezier = "almostLinear" })
-- hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 0.58, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 0.36, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 0.58, bezier = "almostLinear", style = "fade" })
-- hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 2.1,  bezier = "quick" })

-- Ref https://wiki.hypr.land/configuring/core/rules/workspace-rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/configuring/layouts/master-layout/ for more
-- Main ("master") windows sit side by side across the top 70% of the screen.
-- Everything else lines up along the bottom.  mainMod+semicolon adds a second
-- main window; mainMod+v removes one.
hl.config({
    master = {
        -- new_status = "master",
        new_status  = "slave",
        orientation = "top",
        mfact       = 0.70,
    },
})

-- See https://wiki.hypr.land/configuring/layouts/scrolling-layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

-- Tabbed groups (i3's tabbed layout): light tab bar, i3-blue active tab.
hl.config({
    group = {
        groupbar = {
            font_family         = "monospace",
            font_size           = 14,
            height              = 22,
            gradients           = true,
            col = {
                active   = "rgb(5588ff)",
                inactive = "rgb(e8e8e8)",
            },
            text_color          = "rgb(ffffff)",
            text_color_inactive = "rgb(333333)",
        },
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        -- force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        -- disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        -- Color of the separators between windows (and of an empty workspace):
        -- the same dark blue as the waybar text.
        background_color = "rgb(111188)",

        -- When one window is maximized (mainMod+Ctrl+f, used on the laptop screen),
        -- focusing another window maximizes that one instead.
        on_focus_under_fullscreen = 1,

        -- Don't reload when the config files change: switching git branches
        -- (especially between hyprland.conf and hyprland.lua) reloads a
        -- half-checked-out config.  Reload with mainMod+Ctrl+c instead.
        disable_autoreload = true,
    },

    binds = {
        -- mainMod+h/l walk through the tabs of a group before leaving it, like i3.
        movefocus_cycles_groupfirst = true,
        -- mainMod+hjkl also cycles while a window is maximized.
        movefocus_cycles_fullscreen = true,
    },
})


----------------
---- LAYERS ----
----------------

-- The 0.57 example sets layers.allow_new_top_layers_over_existing_fullscreen
-- to its default (true).  Hyprland 0.56 doesn't have that option and rejects
-- the whole hl.config() call, so leave it out.


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        -- kb_options = "",
        -- Caps Lock is another Escape (from ~/settings/Xmodmap).
        kb_options = "caps:escape",
        kb_rules   = "",

        -- Same as `xset r rate 300 30` in ~/settings/fix.
        repeat_delay = 300,
        repeat_rate  = 30,

        -- follow_mouse = 1,
        -- Like `focus_follows_mouse no` in i3: focus changes only on click.
        follow_mouse = 2,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        -- Double mouse-wheel speed (replaces ~/settings/imwheelrc).
        scroll_factor = 2.0,

        touchpad = {
            natural_scroll = false,
            -- Don't double touchpad scrolling along with the mouse wheel.
            scroll_factor  = 0.5,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/configuring/core/binds/ for more
-- hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
-- local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
-- hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
-- hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
-- hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
-- for i = 1, 10 do
--     local key = i % 10 -- 10 maps to key 0
--     hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
--     hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
-- end
-- Right hand only: workspaces 6-10.  Move with Ctrl instead of Shift; like
-- i3, the window moves but focus stays here.
for i = 6, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key,      hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

---- Matt's bindings, ported from ~/settings/i3/config ----

-- Start programs
hl.bind(mainMod .. " + CTRL + I", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + CTRL + U", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + CTRL + O", hl.dsp.exec_cmd("/snap/bin/code || /usr/bin/code"))
hl.bind(mainMod .. " + CTRL + Y", hl.dsp.exec_cmd("~/bin/sunsama || /usr/bin/google-chrome-stable --app=https://app.sunsama.com/group/heisencoder"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd(fileManager))

-- Jump to a particular window type
hl.bind(mainMod .. " + U", hl.dsp.focus({ window = [[class:^([Gg]oogle-chrome)$]] }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ window = [[class:^(com\.mitchellh\.ghostty|kitty|Alacritty|org\.gnome\.Ptyxis)$]] }))
hl.bind(mainMod .. " + O", hl.dsp.focus({ window = [[class:^([Cc]ode|[Cc]ursor)$]] }))
hl.bind(mainMod .. " + P", hl.dsp.focus({ window = [[title:^Zoom Meeting$]] }))
hl.bind(mainMod .. " + Y", hl.dsp.focus({ window = [[title:^Sunsama$]] }))
hl.bind(mainMod .. " + T", hl.dsp.focus({ window = [[class:^chrome-g3c\.corp\.google\.com]] }))

-- Close the focused window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- Move focus (vim keys).  Inside a tab group, h/l step through the tabs first.
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Move the focused window.  Moving into a tab group adds it as a tab; moving
-- away from a group takes it out.  So mainMod+Ctrl+k promotes a bottom window
-- into the main window above it, and mainMod+Ctrl+j sends it back down.
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.move({ direction = "left",  group_aware = true }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.move({ direction = "down",  group_aware = true }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.move({ direction = "up",    group_aware = true }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.move({ direction = "right", group_aware = true }))

-- Alt+Tab: jump back to the previous window.  Alt+Ctrl+Tab: cycle through all.
hl.bind("ALT + Tab",        hl.dsp.focus({ last = true }))
hl.bind("ALT + CTRL + Tab", hl.dsp.window.cycle_next())

-- Layout: add / remove a main window in the top row
hl.bind(mainMod .. " + semicolon", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + V",         hl.dsp.layout("removemaster"))

-- Tabs: mainMod+w turns the focused window into a tab group (or dissolves it);
-- mainMod+e pulls the focused tab out of its group.
hl.bind(mainMod .. " + W", hl.dsp.group.toggle())
hl.bind(mainMod .. " + E", hl.dsp.window.move({ out_of_group = true }))

-- Fullscreen; mainMod+Ctrl+f maximizes instead (one window fills the screen).
hl.bind(mainMod .. " + F",            hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + CTRL + F",     hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + space", hl.dsp.window.float({ action = "toggle" }))

-- Resize.  The 120px side-to-side step divides a half-screen width (960 or
-- 1920) into a power-of-two fraction, which keeps Hyprland 0.53's
-- floating-point window widths exact.  With uneven steps (like 100px), a
-- window touching the right screen edge could end up a fraction of a pixel
-- short of it, so the cursor at the edge didn't reach it (fixed upstream in
-- Hyprland 0.56).
hl.bind(mainMod .. " + CTRL + comma",  hl.dsp.window.resize({ x = -120, y = 0,    relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + period", hl.dsp.window.resize({ x = 120,  y = 0,    relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + slash",  hl.dsp.window.resize({ x = 0,    y = 160,  relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + M",      hl.dsp.window.resize({ x = 0,    y = -160, relative = true }), { repeating = true })

-- Disable the mouse's back/forward buttons (bound buttons don't reach apps).
hl.bind("mouse:275", hl.dsp.no_op())
hl.bind("mouse:276", hl.dsp.no_op())

-- Session: reload, exit, lock, lock + suspend
hl.bind(mainMod .. " + CTRL + C",         hl.dsp.exec_cmd("hyprctl reload"))  -- hl.dsp.reload_config() is 0.57+
hl.bind(mainMod .. " + CTRL + E",         hl.dsp.exec_cmd([[printf 'No\nYes - exit Hyprland\n' | fuzzel --dmenu --prompt 'Exit? ' | grep -q '^Yes' && hyprctl dispatch 'hl.dsp.exit()']]))
hl.bind(mainMod .. " + CTRL + semicolon", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + apostrophe",       hl.dsp.exec_cmd("systemctl suspend"))

-- Notifications
hl.bind(mainMod .. " + minus",        hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + CTRL + minus", hl.dsp.exec_cmd("makoctl dismiss --all"))

-- Display: invert colors (dark mode), night light, monitors
hl.bind(mainMod .. " + comma",  hl.dsp.exec_cmd(scripts .. "/invert.sh"))
hl.bind(mainMod .. " + M",      hl.dsp.exec_cmd("pkill -x gammastep; gammastep -O 2500"))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd("pkill -x gammastep"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(scripts .. "/monitors.sh external"))
hl.bind(mainMod .. " + slash",  hl.dsp.exec_cmd(scripts .. "/monitors.sh all"))

-- Screenshots to ~/Pictures/screenshots and the clipboard
hl.bind("Print",           hl.dsp.exec_cmd(scripts .. "/screenshot.sh"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(scripts .. "/screenshot.sh area"))

-- Volume
hl.bind(mainMod .. " + up",           hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind(mainMod .. " + down",         hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind(mainMod .. " + bracketleft",  hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Workspaces 1-5 have no key bindings (left hand), so keep Hyprland from ever
-- choosing them.  It gives each monitor the lowest free workspace not bound to
-- another monitor; binding 1-6 to a monitor that doesn't exist makes the first
-- monitor start on 7.  mainMod+6 still works ("none" never matches, so 6 opens
-- on the current monitor).
for i = 1, 6 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "none" })
end

-- See https://wiki.hypr.land/configuring/core/rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})

-- Don't let Google Chat or Zoom steal focus when they open (from i3).
hl.window_rule({
    name  = "chat-no-focus",
    match = { class = [[chat\.google\.com]] },

    no_initial_focus = true,
    tile             = true,
})

hl.window_rule({
    name  = "zoom-no-focus",
    match = { title = "^(Zoom|.*zoom.*|.*join.*)$" },

    no_initial_focus = true,
})
