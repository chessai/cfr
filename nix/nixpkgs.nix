{ compiler ? "ghc863" }:
with rec {
  fetchNixpkgs = import ./fetchNixpkgs.nix;
  nixpkgs = fetchNixpkgs {
    owner  = "layer-3-communications";
    repo   = "nixpkgs";
    rev    = "7226ab90843f8cb366f0e6f90ba16e8214e19bdb";
    sha256 = "0zqhzhsi4va2nj3660d61kah7wv7lpmhrmkzk3fhys5w0d548l7h";
  };
};
import nixpkgs {
  config = {
    packageOverrides = super: let self = super.pkgs; in {
      haskellPackages = super.haskell.packages.${compiler}.override {
        overrides = import ./overrides.nix { pkgs = self; };
      };
    };
  };
  overlays = [ ];
}
