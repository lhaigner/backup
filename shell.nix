{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [ pkgs.python3 pkgs.borgbackup pkgs.keepassxc ];
}
