{
  inputs.nixpkgs.url = "https://github.com/NixOS/nixpkgs/archive/a9eb3eed170fa916e0a8364e5227ee661af76fde.tar.gz";
  inputs.nixpkgs.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
  let
    pkgs = import nixpkgs {
      localSystem.system = (if system == "aarch64-darwin" then "x86_64-darwin" else "${system}");
    };
    pypinyin = with pkgs.python3Packages; buildPythonPackage rec {
      pname = "pypinyin";
      version = "0.35.4";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-9LOpfcbNIK1448C3ULgat5JwrPXqC3m5H2QJ7W5CcnE=";
      };
      propagatedBuildInputs = [ enum34 typing ];
      doCheck = false;
    };
  in {
    devShell = pkgs.mkShell {
      nativeBuildInputs = [
        pkgs.ansible
        ((pkgs.python3.withPackages(ps: [
          # ps.ansible
          ps.configparser
          pypinyin
        ])).override (args: { ignoreCollisions = true; }))
      ];
    };
  });
}
