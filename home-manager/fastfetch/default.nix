{ config, pkgs, lib, ... }:
{
# Ensure fastfetch program is enabled
programs.fastfetch = {
enable = true;
package = pkgs.fastfetch; # Make sure fastfetch is available in your pkgs
  };

xdg.configFile."fastfetch/fastfetch-logo.txt".source = ./fastfetch-logo.txt;

xdg.configFile."fastfetch/config.jsonc".text = ''
    {
    "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
        "type": "file",
        "source": "${config.home.homeDirectory}/.config/fastfetch/fastfetch-logo.txt",
        "padding": {
            "top": 1,
            "left": 3,
        }
    },
    "modules": [
        "break",
        {
            "type": "custom",
            "format": "\u001b[90m┌───────────────────────────────────Hardware───────────────────────────────────┐"
        },
        {
            "type": "host",
            "key": "󰌢  PC",
            "keyColor": "green"
        },
        {
            "type": "cpu",
            "key": "│ ├󰻠 ",
            "keyColor": "green"
        },
        {
            "type": "gpu",
            "key": "│ ├󰍹 ",
            "keyColor": "green"
        },
        {
            "type": "memory",
            "key": "│ ├󰑭 ",
            "keyColor": "green"
        },
        {
            "type": "disk",
            "key": "└ └󰋊 ",
            "keyColor": "green"
        },
        {
            "type": "custom",
            "format": "\u001b[90m└──────────────────────────────────────────────────────────────────────────────┘"
        },
        "break",
        {
            "type": "custom",
            "format": "\u001b[90m┌───────────────────────────────────Software───────────────────────────────────┐"
        },
        {
            "type": "os",
            "key": "  OS",
            "keyColor": "yellow"
        },
        {
            "type": "kernel",
            "key": "│ ├󰌽 ",
            "keyColor": "yellow"
        },
        {
            "type": "bios",
            "key": "│ ├󰖡 ",
            "keyColor": "yellow"
        },
        {
            "type": "packages",
            "key": "│ ├󰏗 ",
            "keyColor": "yellow"
        },
        {
            "type": "shell",
            "key": "└ └󰞷 ",
            "keyColor": "yellow"
        },
        "break",
        {
            "type": "wm",
            "key": "󰧨  WM",
            "keyColor": "blue"
        },
        {
            "type": "lm",
            "key": "│ ├󰍁 ",
            "keyColor": "blue"
        },
        {
            "type": "wmtheme",
            "key": "│ ├󰉦 ",
            "keyColor": "blue"
        },
        {
            "type": "terminal",
            "key": "└ └󰆍 ",
            "keyColor": "blue"
        },
        {
            "type": "custom",
            "format": "\u001b[90m└──────────────────────────────────────────────────────────────────────────────┘"
        },
        "break"
    ]
}
    '';


}
