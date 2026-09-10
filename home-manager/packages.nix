{ inputs, pkgs, pkgsBundle, myOptions, ... }:
{
  home.packages = (with pkgs; [
    (pkgs.writeShellScriptBin "envssh" (builtins.readFile ./scripts/envssh.sh))
    (pkgs.writeShellScriptBin "pia-switch" (builtins.readFile ./scripts/pia-switch.sh))
    (pkgs.writeShellScriptBin "lunet-setup" (builtins.readFile ./scripts/lunet-setup.sh))
  ]);
}
