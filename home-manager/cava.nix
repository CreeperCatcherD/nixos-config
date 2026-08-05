{ ... }: {
  programs.cava = {
    enable = true;
    settings = {
      color = {
        # Pre-seeded so Noctalia's cava apply-hook (which sed-patches this
        # file at runtime) sees "noctalia" already selected and no-ops
        # instead of trying to write through the Nix-store symlink.
        theme = "noctalia";
      };
    };
  };
}