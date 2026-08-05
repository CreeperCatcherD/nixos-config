{ pkgs, myOptions, ... }:

let
  btopWithGpu = pkgs.btop.override {
    rocmSupport = myOptions.enable-amd-gpu;
    cudaSupport = myOptions.enable-nvidia-gpu;
  };
in
{
  programs.btop = {
    enable = true;
    package = btopWithGpu;
    
    settings = {
      # Pre-seeded so Noctalia's btop apply-hook (which sed-patches this
      # file at runtime) sees "noctalia" already selected and no-ops
      # instead of trying to write through the Nix-store symlink.
      color_theme = "noctalia";
      theme_background = false;
      update_ms = 200;
      # On Auto Off
      shown_boxes = "cpu mem net proc gpu0";
    };
  };

  home.packages = (with pkgs; [ 
    nvtopPackages.intel
  ]);
}