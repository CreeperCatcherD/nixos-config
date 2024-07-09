{
  description = "My system configuration";

  inputs = {

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stylix.url = "github:danth/stylix";

    #nur.url = "github:nix-community/NUR";
  
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
  
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
  
    #nix-gaming.url = "github:fufexan/nix-gaming";
  
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-cava = {
      url = "github:catppuccin/cava";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... } @ inputs:

    let
      username = "kleind";
      system = "x86_64-linux";
      pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
    in {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./hosts/desktop)
            inputs.stylix.nixosModules.stylix];
          specialArgs = { host="desktop"; inherit self inputs username pkgs-stable ; };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./hosts/laptop)
            inputs.stylix.nixosModules.stylix];
          specialArgs = { host="laptop"; inherit self inputs username pkgs-stable ; };
        };
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./hosts/vm)
            inputs.stylix.nixosModules.stylix];
          specialArgs = { host="vm"; inherit self inputs username pkgs-stable ; };
        };
      };

      #homeConfigurations.nixuser = home-manager.lib.homeManagerConfiguration {
      #  pkgs = nixpkgs.legacyPackages.${system};
      #  modules = [ ./home-manager/home.nix ];
      #};
    };
}
