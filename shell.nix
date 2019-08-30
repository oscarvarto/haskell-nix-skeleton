let
  ghcPtr = import ./nix/nix-ghc-ptr.nix;
  pinnedPkgs = ghcPtr.pinnedPkgs;
  myPackages = (import ./release.nix { withHoogle = true; } );
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};

  projectDrvEnv = myPackages.project1.env.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [
      pinnedPkgs.haskellPackages.cabal-install
      pinnedPkgs.haskellPackages.hlint
      all-hies.versions.${ghcPtr.hieVer}
      (pinnedPkgs.vscode-with-extensions.override {
        vscodeExtensions = with pinnedPkgs.vscode-extensions; [
          alanz.vscode-hie-server
        ]
        ++ pinnedPkgs.vscode-utils.extensionsFromVscodeMarketplace [{
            name = "language-haskell";
            publisher = "justusadam";
            version = "2.6.0";
            sha256 = "1891pg4x5qkh151pylvn93c4plqw6vgasa4g40jbma5xzq8pygr4";
        }];
      })
    ];
    shellHook = ''
      export USERNAME="oscarvarto"
      export HIE_HOOGLE_DATABASE="$NIX_GHC_LIBDIR/../../share/doc/hoogle/index.html"
    '';
  });
in
projectDrvEnv
