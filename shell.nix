{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [ pkgs.pipenv pkgs.borgbackup pkgs.keepassxc ];
}
