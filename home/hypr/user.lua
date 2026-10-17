-- Personal config, loaded by Caelestia's hyprland.lua after its own config.

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("skwd-wall-v2"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("wofi --show drun"))
