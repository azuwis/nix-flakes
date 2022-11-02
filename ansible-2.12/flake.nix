{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.devshell.inputs.nixpkgs.follows = "nixpkgs";
  inputs.devshell.inputs.flake-utils.follows = "flake-utils";

  outputs = { self, nixpkgs, flake-utils, devshell }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = nixpkgs.legacyPackages.${system};
    mkShell = devshell.legacyPackages.${system}.mkShell;
  in {
    devShell = mkShell {
      packages = [
        # pkgs.ansible
        (pkgs.python3.withPackages(ps: [
          ps.ansible-core
        ]))
      ];
    };
  });
}
