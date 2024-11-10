{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.ghc
    pkgs.ghcid
    pkgs.cabal-install
    pkgs.ormolu
  ];
}
