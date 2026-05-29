{ pkgs, myOptions, ... }: {
    virtualisation.docker = {
      enable = true;
    };
    users.users.${myOptions.username}.extraGroups = [ "docker" ];
}