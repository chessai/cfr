{ pkgs }:

self: super:

with { inherit (pkgs.stdenv) lib; };

with pkgs.haskell.lib;

{
  cfr = (
    with rec {
      cfrSource = pkgs.lib.cleanSource ../.;
      cfrBasic  = self.callCabal2nix "cfr" cfrSource { };
    };
    overrideCabal cfrBasic (old: {
    })
  );
}
