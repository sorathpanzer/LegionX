{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.rustc
    pkgs.rust-analyzer
    pkgs.rustfmt
    pkgs.cargo
    pkgs.openssl
    pkgs.gnupg
    pkgs.clippy
    pkgs.bacon
  ];
  RUST_BACKTRACE = 1;
}
