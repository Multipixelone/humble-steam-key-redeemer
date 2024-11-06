{
  description = "Script to auto-redeem keys from humble-bundle on steam";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pythonEnv = let
        steam = pkgs.python3Packages.callPackage ./steam.nix {
          buildPythonPackage =
            pkgs.python3Packages.buildPythonPackage;
          protobuf = pkgs.python3Packages.protobuf4;
        };
      in
        pkgs.python3.withPackages (ps: [
          steam
          ps.fuzzywuzzy
          ps.requests
          ps.selenium
          ps.pwinput
          ps.levenshtein
        ]);
      app = pkgs.python3Packages.buildPythonApplication rec {
        pname = "humblesteamkeysredeemer";
        version = "1.0";
        format = "other";
        src = ./.;

        propagatedBuildInputs = [
          pythonEnv
        ];

        dontUnpack = true;
        doCheck = false;
        pytestCheckHook = false;

        installPhase = ''
          install -Dm755 ${src}/humblesteamkeysredeemer.py $out/bin/${pname}
          sed -i '1s|^|#!/usr/bin/env python3\n|' $out/bin/${pname}
        '';
        meta.mainProgram = "humblesteamkeysredeemer";
      };
    in {
      packages = {
        humble-key = app;
        default = self.packages.${system}.humble-key;
      };
    });
}
