{ pkgs, pkgsBundle, lib, myOptions, ... }: {

  # TODO: Make Stable
  environment.systemPackages = with pkgsBundle.pkgs-stable; [
    (if myOptions.enable-nvidia-gpu then (blender.override {cudaSupport=true;}) else (blender))
  ];
}
