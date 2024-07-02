{ ... }: 
{
  imports = [ (import ./ampere.nix)   ];
  
  #[ (import ./waybar.nix)   ]
  #        ++ [ (import ./settings.nix) ]
  #        ++ [ (import ./style.nix)    ];
}
