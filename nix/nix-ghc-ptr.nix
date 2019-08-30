{
  hieVer = "ghc864";
  # pinnedPkgs = import ./pkgs-from-json.nix { json = ./pkgs/nix-ghc864.json; };
  pinnedPkgs = import (fetchTarball { 
      url = "https://github.com/NixOS/nixpkgs/tarball/master";
      #sha256 = "..."; 
    }) {};
}