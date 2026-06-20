{ config, inputs, lib, myOptions, pkgs, ... }: 
let
  parseMonitor = str:
    let
      parts = builtins.filter (x: builtins.isString x && x != "") (builtins.split ",[[:space:]]*" str);
    in
    {
      _args = [
        {
          output = builtins.elemAt parts 0;      # Changed from name to output
          mode = builtins.elemAt parts 1;
          position = builtins.elemAt parts 2;
          scale = builtins.elemAt parts 3;
        }
      ];
    };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces
      # inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    settings = {
      mainMod = {
        _var = "SUPER";
      };

      # Global plugin configuration paths
      "config.plugin.split_monitor_workspaces.monitor_priority" = [
        { _args = [ [ "DP-1" "DP-2" ] ]; }
      ];

      "config.plugin.split_monitor_workspaces.max_workspaces" = [
        { _args = [ { monitor = "DP-1"; max = 9; } ]; }
        { _args = [ { monitor = "DP-2"; max = 5; } ]; }
      ];

      # monitor = [] ++ myOptions.screens ++ [ ",preferred,auto,1" ];
      monitor = (builtins.map parseMonitor myOptions.screens) ++ [
        { _args = [ { output = ""; mode = "preferred"; position = "auto"; scale = "1"; } ]; }
      ];

      env = [
        { _args = [ "XDG_CURRENT_DESKTOP" "Hyprland" ]; }
        { _args = [ "XDG_SESSION_TYPE" "wayland" ]; }
        { _args = [ "XDG_SESSION_DESKTOP" "Hyprland" ]; }
        { _args = [ "XCURSOR_SIZE" "36" ]; }
        { _args = [ "XDG_SCREENSHOTS_DIR" "~/Pictures/Screenshots" ]; }
      ];
      
      # debug = {
      #   disable_logs = false;
      #   enable_stdout_logs = true;
      #   disable_scale_checks = true;
      # };

      # input = {
      #   kb_layout = "us";
      #   kb_variant = "";
      #   kb_options = "";
      #   follow_mouse = 1;
      #   touchpad = {
      #     natural_scroll = true;
      #   };
      #   sensitivity = 0;
      # };

      # general = {
      #   gaps_in = 5;
      #   gaps_out = 18;
      #   border_size = 3;
        
      #   "col.active_border" = let
      #     accentColor1 = config.lib.stylix.colors.base0D;
      #     accentColor2 = config.lib.stylix.colors.base0B;
      #   in lib.mkForce "rgb(${accentColor1}) rgb(${accentColor2}) rgb(${accentColor1}) 45deg";

      #   "col.inactive_border" = let
      #     inactiveColor = config.lib.stylix.colors.base03;
      #   in lib.mkForce "rgb(${inactiveColor})";

      #   layout = "dwindle";
      # };

      # decoration = {
      #   rounding = 10;
      #   blur = {
      #     enabled = true;
      #     size = 2;
      #     passes = 2;
      #     new_optimizations = true;
      #   };
      # };

      # animations = {
      #   enabled = true;
      #   bezier = "myBezier, 0.1, 0.9, 0.1, 1.1";
      #   animation = [
      #     "windows,     1, 7,  myBezier"
      #     "windowsOut,  1, 7,  default, popin 80%"
      #     "border,      1, 10, default"
      #     "borderangle, 1, 8,  default"
      #     "fade,        1, 7,  default"
      #     "workspaces,  1, 6,  default"
      #   ];
      # };

      # dwindle = {
      #   preserve_split = true;
      # };

      # master = {
      #   new_status = "master";
      # };
      
      # misc = {
      #   animate_manual_resizes = true;
      #   animate_mouse_windowdragging = true;
      #   enable_swallow = true;
      #   disable_hyprland_logo = true;
      #   enable_anr_dialog = false;
      # };

      # Converted from exec-once list into hl.exec_cmd(...) syntax using _args
      exec_cmd = map (cmd: { _args = [ cmd ]; }) ([
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd &"
        "nm-applet &"
        "swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &"
        "sleep 1 && swaylock"
        "poweralertd &"
        "waybar &"
        "mako &"
        "wl-paste -t text --watch cliphist store &"
        "wl-paste -p -t text --watch cliphist store &"
        "wl-paste -p --watch xclip -i -selection primary &"
      ] ++ (if myOptions.enable-rgb-lights then ["(sleep 6 && openrgb --startminimized) &"] else []));

      bind = [
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + V"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + Return"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + Q"'') (lib.generators.mkLuaInline ''hl.dsp.window.kill()'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + A"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("hyprctl reload")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + R"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("obsidian")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + C"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("codium")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + E"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("nemo ~")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + G"'') (lib.generators.mkLuaInline ''hl.dsp.window.float({})'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + F"'') (lib.generators.mkLuaInline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + D"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("wofi --show drun")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + P"'') (lib.generators.mkLuaInline ''hl.dsp.window.pseudo({})'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + P"'') (lib.generators.mkLuaInline ''hl.dsp.window.pin({})'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + T"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + L"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("swaylock")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + S"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("firefox")'') ]; }

        # { _args = [ "ALT + Tab" (lib.generators.mkLuaInline ''hl.dsp.window.center({})'') ]; }
        # { _args = [ "ALT + Tab" (lib.generators.mkLuaInline ''hl.dsp.window.cycle_next({})'') ]; }
        # { _args = [ "ALT + SHIFT + Tab" (lib.generators.mkLuaInline ''hl.dsp.window.cycle_next({ next = false })'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + left"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "l" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + right"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "r" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + up"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "u" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + down"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ direction = "d" })'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + left"'') (lib.generators.mkLuaInline ''hl.dsp.window.swap({ direction = "l" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + right"'') (lib.generators.mkLuaInline ''hl.dsp.window.swap({ direction = "r" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + up"'') (lib.generators.mkLuaInline ''hl.dsp.window.swap({ direction = "u" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + down"'') (lib.generators.mkLuaInline ''hl.dsp.window.swap({ direction = "d" })'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 1"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"1*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 2"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"2*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 3"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"3*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 4"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"4*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 5"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"5*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 6"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"6*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 7"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"7*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 8"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"8*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 9"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"9*\") --no-video")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + 0"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill mpv")'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + CTRL + left"'') (lib.generators.mkLuaInline ''hl.dsp.window.resize({ x = -60, y = 0, relative = true })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + CTRL + right"'') (lib.generators.mkLuaInline ''hl.dsp.window.resize({ x = 60, y = 0, relative = true })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + CTRL + up"'') (lib.generators.mkLuaInline ''hl.dsp.window.resize({ x = 0, y = -60, relative = true })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + CTRL + down"'') (lib.generators.mkLuaInline ''hl.dsp.window.resize({ x = 0, y = 60, relative = true })'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 1"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(1)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 2"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(2)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 3"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(3)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 4"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(4)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 5"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(5)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 6"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(6)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 7"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(7)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 8"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(8)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 9"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(9)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + 0"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.workspace(10)) end'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 1"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(1)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 2"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(2)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 3"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(3)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 4"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(4)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 5"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(5)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 6"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(6)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 7"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(7)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 8"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(8)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 9"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(9)) end'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + 0"'') (lib.generators.mkLuaInline ''function() return hl.dispatch(hl.plugin.split_monitor_workspaces.move_to_workspace_silent(10)) end'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + mouse:276"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e+1" })'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + mouse:275"'') (lib.generators.mkLuaInline ''hl.dsp.focus({ workspace = "e-1" })'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + F3"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl -d *::kbd_backlight set +33%")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + F2"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl -d *::kbd_backlight set 33%-")'') ]; }

        { _args = [ "XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -i 5")'') ]; }
        { _args = [ "XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -d 5")'') ]; }
        { _args = [ "XF86AudioMute" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -t")'') ]; }
        { _args = [ "XF86AudioMicMute" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer --default-source --toggle-mute")'') ]; }
        # { _args = [ "XF86AudioPlayPause" (lib.generators.mkLuaInline ''function() hl.dsp.exec_cmd("playerctl --all-players play-pause") end'') ]; }
        { _args = [ "XF86AudioPlay" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl --all-players play-pause")'') ]; }
        { _args = [ "XF86AudioPause" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl --all-players play-pause")'') ]; }
        { _args = [ "XF86AudioNext" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'') ]; }
        { _args = [ "XF86AudioPrev" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + right"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -t")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + up"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -i 5")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + down"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -d 5")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + left"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl --all-players play-pause")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + m"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer --default-source --toggle-mute")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + CTRL + right"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl next")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + ALT + CTRL + left"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("playerctl previous")'') ]; }
        # { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + S + mouse_down"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -i 5")'') ]; }
        # { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + S + mouse_up"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pamixer -d 5")'') ]; }
        
        { _args = [ "XF86MonBrightnessDown" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 5%-")'') ]; }
        { _args = [ "XF86MonBrightnessUp" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("brightnessctl set 5%+")'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + B"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill -SIGUSR1 waybar")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + W"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill -SIGUSR2 waybar")'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + G"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("~/.config/hypr/gamemode.sh")'') ]; }

        { _args = [ "Print" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -")'') ]; }
        { _args = [ "CTRL + Print" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy")'') ]; }
        { _args = [ "SHIFT + Print" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grim -g \"$(slurp)\" - $(find $HOME -name Pictures -maxdepth 1)/Screenshots/$(date +'%s_grim.png')")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + CTRL + C"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grim \"/home/nixuser/Pictures/Cheat/$(date +'%Y-%m-%d_%H-%M-%S_full.png')\"")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + C"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("LATEST_FILE=$(ls -1 /home/nixuser/tmp/laptop/Pictures/Cheat/*.png 2>/dev/null | tail -n 1) && cat \"$LATEST_FILE\" | wl-copy --type \"$(file -b --mime-type \"$LATEST_FILE\")\"")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + CTRL + C"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("(mkdir -p /home/nixuser/Pictures/Cheat && while true; do grim \"/home/nixuser/Pictures/Cheat/$(date +'%Y-%m-%d_%H-%M-%S_full.png')\"; sleep 30; done)")'') ]; }
        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + T"'') (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("pkill -f 'grim /home/nixuser/Pictures/Cheat'")'') ]; }

        { _args = [ (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + V"'') (lib.generators.mkLuaInline ''hl.dsp.submap("vnc")'') ]; }

        { 
          _args = [ 
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + CTRL + O"'') 
            (lib.generators.mkLuaInline ''function() hl.dsp.exec_cmd("(swaylock & (sleep 0.01 && systemctl suspend))") end'') 
          ];
          flags = { locked = true; }; # Home Manager translates this attribute to the Lua config flags
        }
        { 
          _args = [ 
            (lib.generators.mkLuaInline ''mainMod .. " + O"'') 
            (lib.generators.mkLuaInline ''function() hl.dsp.dpms({ action = "disable" }) end'') 
          ];
          flags = { locked = true; };
        }
        { 
          _args = [ 
            (lib.generators.mkLuaInline ''mainMod .. " + SHIFT + O"'') 
            (lib.generators.mkLuaInline ''function() hl.dsp.dpms({ action = "enable" }) end'') 
          ];
          flags = { locked = true; };
        }

        { 
          _args = [ 
            (lib.generators.mkLuaInline ''mainMod .. " + mouse:272"'')
            (lib.generators.mkLuaInline ''function() hl.dsp.window.drag() end'')
          ];
          flags = { mouse = true; };
        }
        { 
          _args = [ 
            (lib.generators.mkLuaInline ''mainMod .. " + mouse:273"'')
            (lib.generators.mkLuaInline ''function() hl.dsp.window.resize() end'')
          ];
          flags = { mouse = true; };
        }
      ];
    };

    # extraConfig = ''
    #   submap = vnc
    #   bind = $mainMod SHIFT, V, submap, reset
    #   submap = reset
    # '';
  };
}