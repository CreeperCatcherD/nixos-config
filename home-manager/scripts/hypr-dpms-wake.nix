{ pkgs }:
pkgs.writeShellApplication {
  name = "hypr-dpms-wake";
  runtimeInputs = [ pkgs.jq ];
  text = builtins.readFile ./hypr_dpms_wake.sh;
}
