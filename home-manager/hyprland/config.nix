{ inputs, config, lib, myOptions, pkgs, ... }: 
{
  wayland.windowManager.hyprland = {

    plugins = [ inputs.split-monitor-workspaces.packages.${pkgs.stdenv.hostPlatform.system}.split-monitor-workspaces ];

    settings = {
      "$mainMod" = "SUPER";

      # "plugin:touch_gestures" = {
      #   # The default sensitivity is probably too low on tablet screens,
      #   # I recommend turning it up to 4.0
      #   sensitivity = 1.0;

      #   # must be >= 3
      #   workspace_swipe_fingers = 3;

      #   # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
      #   # and can be used at the same time
      #   # possible values: l, r, u, or d
      #   # to disable it set it to anything else
      #   workspace_swipe_edge = "d";

      #   # in milliseconds
      #   long_press_delay = 400;

      #   # in pixels, the distance from the edge that is considered an edge
      #   edge_margin = 10;

      #   experimental = {
      #     # send proper cancel events to windows instead of hacky touch_up events,
      #     # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
      #     send_cancel = 0;
      #   };
      # };

      monitor = [] ++ myOptions.screens ++ [ ",preferred,auto,1" ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XCURSOR_SIZE,36"
        # "QT_QPA_PLATFORM,wayland"
        "XDG_SCREENSHOTS_DIR,~/Pictures/Screenshots"
      ];

      debug = {
        disable_logs = false;
        enable_stdout_logs = true;
        # For fractional scaling
        disable_scale_checks = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "";
        kb_options = "";

        follow_mouse = 1;

        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      };

      general = {
        gaps_in = 5;
        gaps_out = 18;
        border_size = 3;

        # col.active_border / col.inactive_border are set in extraConfig
        # below, after Noctalia's generated colors are sourced (they use
        # Noctalia's $primary/$secondary/$surface variables, which must be
        # defined before use).

        layout = "dwindle";

        #no_cursor_warps = false;
      };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          size = 2;
          passes = 2;
          new_optimizations = true;
        };

        # drop_shadow = true;
        # shadow_range = 4;
        # shadow_render_power = 3;
        # "col.shadow" = "rgba(1a1a1aee)";
      };

      animations = {
        enabled = true;

        # bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        # bezier = "myBezier, 0.33, 0.82, 0.9, -0.08";
        bezier = "myBezier, 0.1, 0.9, 0.1, 1.1";

        animation = [
          "windows,     1, 7,  myBezier"
          "windowsOut,  1, 7,  default, popin 80%"
          "border,      1, 10, default"
          "borderangle, 1, 8,  default"
          "fade,        1, 7,  default"
          "workspaces,  1, 6,  default"
        ];
      };

      dwindle = {
        # pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true; # you probably want this
      };

      master = {
        new_status = "master";
      };
      
      #TODO Fix Gestures
      # gestures = {
      #   workspace_swipe = true;
      #   workspace_swipe_fingers = 3;
      #   workspace_swipe_invert = false;
      #   workspace_swipe_distance = 200;
      #   workspace_swipe_forever = true;
      # };

      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        enable_swallow = true;
        # render_ahead_of_time = false;
        disable_hyprland_logo = true;
        enable_anr_dialog = false;
      };

      # autostart
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd &"
        "nm-applet &"
        "noctalia &"
        # "hyprctl setcursor Nordzy-cursors 22 &"
        "poweralertd &"
        # "mako &"
        "wl-paste -t text --watch cliphist store &"
        "wl-paste -p -t text --watch cliphist store &"
        "wl-paste -p --watch xclip -i -selection primary &"
      ] ++ (if myOptions.enable-rgb-lights then ["(sleep 6 && openrgb --startminimized) &"] else []);


      bind = [
        "$mainMod, V, exec, noctalia msg panel-toggle clipboard"

        "$mainMod, Return, exec, kitty"
        "$mainMod, Q, killactive,"
        # "$mainMod, M, exit,"
        "$mainMod, A, exec, ${pkgs.writeShellScriptBin "hypr-reload-restore-workspaces" (builtins.readFile ../scripts/hypr_reload_restore_workspaces.sh)}/bin/hypr-reload-restore-workspaces"
        "$mainMod, R, exec, obsidian"
        "$mainMod, C, exec, codium"
        "$mainMod, E, exec, nemo ~"
        "$mainMod, H, exec, hyprpicker -a" # pick a color, copy to clipboard
        "$mainMod, G, togglefloating,"
        "$mainMod, F, fullscreenstate, 2"
        "$mainMod, D, exec, noctalia msg panel-toggle launcher"
        "$mainMod SHIFT, P, pseudo, # dwindle"
        "$mainMod, P, pin"
        # "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, T, exec, kitty"
        "$mainMod, L, exec, noctalia msg session lock"
        "$mainMod, S, exec, firefox"

        # Cycle through windows
        "ALT, Tab, bringactivetotop,"
        "ALT, Tab, cyclenext,"
        "ALT SHIFT, Tab, cyclenext, prev"

        # Move focus with mainMod + arrow keys
        "$mainMod, left,  movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up,    movefocus, u"
        "$mainMod, down,  movefocus, d"

        # Moving windows
        "$mainMod SHIFT, left,  swapwindow, l"
        "$mainMod SHIFT, right, swapwindow, r"
        "$mainMod SHIFT, up,    swapwindow, u"
        "$mainMod SHIFT, down,  swapwindow, d"

        # Audio clip hotkeys
        "$mainMod ALT, 1, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"1*\") --no-video"
        "$mainMod ALT, 2, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"2*\") --no-video"
        "$mainMod ALT, 3, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"3*\") --no-video"
        "$mainMod ALT, 4, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"4*\") --no-video"
        "$mainMod ALT, 5, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"5*\") --no-video"
        "$mainMod ALT, 6, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"6*\") --no-video"
        "$mainMod ALT, 7, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"7*\") --no-video"
        "$mainMod ALT, 8, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"8*\") --no-video"
        "$mainMod ALT, 9, exec, mpv $(find ~/Music/clips -maxdepth 1 -type f -name \"9*\") --no-video"
        "$mainMod ALT, 0, exec, pkill mpv"

        # Window resizing                     X  Y
        "$mainMod CTRL, left,  resizeactive, -60 0"
        "$mainMod CTRL, right, resizeactive,  60 0"
        "$mainMod CTRL, up,    resizeactive,  0 -60"
        "$mainMod CTRL, down,  resizeactive,  0  60"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1, split-workspace, 1"
        "$mainMod, 2, split-workspace, 2"
        "$mainMod, 3, split-workspace, 3"
        "$mainMod, 4, split-workspace, 4"
        "$mainMod, 5, split-workspace, 5"
        "$mainMod, 6, split-workspace, 6"
        "$mainMod, 7, split-workspace, 7"
        "$mainMod, 8, split-workspace, 8"
        "$mainMod, 9, split-workspace, 9"
        "$mainMod, 0, split-workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1, split-movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, split-movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, split-movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, split-movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, split-movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, split-movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, split-movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, split-movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, split-movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, split-movetoworkspacesilent, 10"

        # Scroll through existing workspaces with mainMod + side buttons
        # "$mainMod, mouse_down, workspace, e+1"
        # "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, mouse:276, workspace, e+1"
        "$mainMod, mouse:275, workspace, e-1"
        #"$mainMod SHIFT, mouse:276, workspace, e+5"
        #"$mainMod SHIFT, mouse:275, workspace, e-5"

        # Keyboard backlight
        "$mainMod, F3, exec, brightnessctl -d *::kbd_backlight set +33%"
        "$mainMod, F2, exec, brightnessctl -d *::kbd_backlight set 33%-"

        # Volume and Media Control
        ", XF86AudioRaiseVolume, exec, pamixer -i 5 "
        ", XF86AudioLowerVolume, exec, pamixer -d 5 "
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86AudioMicMute, exec, pamixer --default-source --toggle-mute"
        ", XF86AudioPlayPause, exec, playerctl --all-players play-pause"
        ", XF86AudioPlay, exec, playerctl --all-players play-pause"
        ", XF86AudioPause, exec, playerctl --all-players play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        "$mainMod ALT, right, exec, pamixer -t"
        "$mainMod ALT, up, exec, pamixer -i 5"
        "$mainMod ALT, down, exec, pamixer -d 5"
        "$mainMod ALT, left, exec, playerctl --all-players play-pause"
        "$mainMod ALT, m, exec, pamixer --default-source --toggle-mute"
        "$mainMod ALT CTRL, right, exec, playerctl next"
        "$mainMod ALT CTRL, left, exec, playerctl previous"
        "$mainMod S, mouse_down, exec, pamixer -i 5"
        "$mainMod S, mouse_up, exec, pamixer -d 5"
        
        # Brightness control
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"

        # Configuration files
        # ''$mainMod SHIFT, N, exec, alacritty -e sh -c "rb"''
        # ''$mainMod SHIFT, C, exec, alacritty -e sh -c "conf"''
        # ''$mainMod SHIFT, H, exec, alacritty -e sh -c "codium ~/nix/home-manager/modules/wms/hyprland.nix"''
        # ''$mainMod SHIFT, W, exec, alacritty -e sh -c "codium ~/nix/home-manager/modules/wms/waybar.nix''

        # Noctalia recovery - not run as a systemd service, so if it
        # crashes or hangs it needs a manual kick to come back.
        "$mainMod, B, exec, pkill -x noctalia; sleep 0.3; noctalia &" # graceful restart
        "$mainMod, W, exec, pkill -9 -x noctalia; sleep 0.3; noctalia &" # force restart if hung

        # Disable all effects
        "$mainMod Shift, G, exec, ~/.config/hypr/gamemode.sh "

        # Screenshots
        #, print, exec, $HOME/.config/hypr/scripts/screenshots/captureAll.sh
        #CTRL, print, exec, $HOME/.config/hypr/scripts/screenshots/captureScreen.sh
        #CTRL SHIFT, print, exec, $HOME/.config/hypr/scripts/screenshots/captureArea.sh

        # Screenshots
        '', Print, exec, grim -g "$(slurp)" - | swappy -f -''
        ''CTRL, Print, exec, grim -g "$(slurp)" - | wl-copy''
        ''SHIFT, Print, exec, grim -g "$(slurp)" - $(find $HOME -name Pictures -maxdepth 1)/Screenshots/$(date +'%s_grim.png')''
        "$mainMod CTRL, C, exec, grim \"/home/nixuser/Pictures/Cheat/$(date +'%Y-%m-%d_%H-%M-%S_full.png')\""
        "$mainMod SHIFT, C, exec, LATEST_FILE=$(ls -1 /home/nixuser/tmp/laptop/Pictures/Cheat/*.png 2>/dev/null | tail -n 1) && cat \"$LATEST_FILE\" | wl-copy --type \"$(file -b --mime-type \"$LATEST_FILE\")\""
        "$mainMod SHIFT CTRL, C, exec, (mkdir -p /home/nixuser/Pictures/Cheat && while true; do grim \"/home/nixuser/Pictures/Cheat/$(date +'%Y-%m-%d_%H-%M-%S_full.png')\"; sleep 30; done) &"
        "$mainMod SHIFT, T, exec, pkill -f 'grim /home/nixuser/Pictures/Cheat'"
        # ", print, exec, $(find $HOME -name Pictures -maxdepth 1)/Screenshots/$(date +'%s_grim.png')"
        # "CTRL, print, exec, grim -g \"$(slurp -o)\" $(find $HOME -name Pictures -maxdepth 1)/Screenshots/$(date +'%s_grim.png')"
        # "CTRL SHIFT, print, exec, grim -g \"$(slurp)\" $(find $HOME -name Pictures -maxdepth 1)/Screenshots/$(date +'%s_grim.png')"
        # ", print, exec, grim ~/Screenshots/$(date +'%s_grim.png')"
        # # ", print, exec, kitty"
        # "CTRL, print, exec, grim -g \"$(slurp -o)\" $(xdg-user-dir Pictures)/Screenshots/$(date +'%s_grim.png')"
        # "CTRL SHIFT, print, exec, grim -g \"$(slurp)\" $(xdg-user-dir Pictures)/Screenshots/$(date +'%s_grim.png')"

        "$mainMod SHIFT, V, submap, vnc"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindl = [
        # Screen and sleep hotkeys
        "$mainMod SHIFT CTRL, O, exec, noctalia msg session lock-and-suspend"
        # "$mainMod, O, exec,  hyprctl dispatch dpms off"
        # "$mainMod SHIFT, O, exec,  hyprctl dispatch dpms on"
        # "$mainMod, O, exec, ${
        #   pkgs.writeShellScriptBin "dpms-toggle-ephemeral" (
        #     # 1. Read the script content from the external file
        #     builtins.readFile ../scripts/dpms_toggle.sh
        #   )
        # }/bin/dpms-toggle-ephemeral"
        "$mainMod, O, exec,  hyprctl dispatch dpms off"
        "$mainMod SHIFT, O, exec,  hyprctl dispatch dpms on"
      ];
    };
    # Use extraConfig to define the submaps with raw Hyprland syntax
    # This is a string, not a Nix attribute set.
    extraConfig = ''
      # For Noctalia Color templates - must come before anything using
      # $primary/$secondary/$surface below.
      source = ~/.config/hypr/noctalia.conf

      general {
        col.active_border = $primary $secondary 45deg
        col.inactive_border = $surface
      }

      submap = vnc
      # Only this keybind works while in the VNC submap.
      # Press Super+V again to exit the submap.
      bind = $mainMod SHIFT, V, submap, reset

      submap = reset
    '';
  };
}
