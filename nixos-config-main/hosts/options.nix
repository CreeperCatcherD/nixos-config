{ config, pkgs, ... }: {
  # Common options for all machines (modify as needed)
  common = {
    username = "kleind";
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
  };

  # Machine specific configurations
  desktop = {
    # Desktop specific options
    inherit config pkgs ... ;  # Inherit everything by default
    #shadowInheritance = [common];  # Shadow inherit common options
  };
  laptop = {
    # Laptop specific options
    inherit config pkgs ... ;  # Inherit everything by default
    #shadowInheritance = [common];  # Shadow inherit common options
  };
  vm = {
    # VM specific options
    inherit config pkgs ... ;  # Inherit everything by default
    #shadowInheritance = [common];  # Shadow inherit common options
  };

  # Optional: Define default values in common section
  defaults = {
    # Example: Default for a variable
    myDefaultOption = "default_value";
  };
}
