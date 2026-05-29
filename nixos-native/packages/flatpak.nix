{ inputs, ... } : {

  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true;
    packages = [
      # { appId = "com.brave.Browser"; origin = "flathub";  }
      # "com.obsproject.Studio"
      # "im.riot.Riot"
      { appId = "com.bambulab.BambuStudio"; origin = "flathub";  }
      "org.vinegarhq.Sober"
    ];
  };

}