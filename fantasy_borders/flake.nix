{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/62b852f6c6742134ade1abdd2a21685fd617a291";
    hyprland.url = "github:hyprwm/hyprland/c2805aad92978577a4d89b14f1c4f51e50247547";

    hyprland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, hyprland, ... }: let
    inherit (hyprland.inputs) nixpkgs;
    hyprlandSystems = fn: nixpkgs.lib.genAttrs (builtins.attrNames hyprland.packages) (system: fn system nixpkgs.legacyPackages.${system});
  in {
    packages = hyprlandSystems (system: pkgs: let
      hyprlandPackage = hyprland.packages.${system}.hyprland;
    in rec {
      fantasy_borders = hyprlandPackage.stdenv.mkDerivation {
        pname = "fantasy_borders";
        version = "0.1";
        src = ./.;

        nativeBuildInputs = with pkgs; [ cmake pkg-config ];

        buildInputs = with pkgs; [
          hyprlandPackage.dev
          pango
          cairo
        ] ++ hyprlandPackage.buildInputs;

        # no noticeable impact on performance and greatly assists debugging
        cmakeBuildType = "Debug";
        dontStrip = true;

        meta = with pkgs.lib; {
          license = licenses.gpl3;
          platforms = platforms.linux;
        };
      };

      default = fantasy_borders;
    });

    devShells = hyprlandSystems (system: pkgs: {
      default = pkgs.mkShell.override {
        stdenv = pkgs.gcc13Stdenv;
      } {
        name = "fantasy_borders";

        nativeBuildInputs = with pkgs; [
          clang-tools_16
          bear
        ];

        inputsFrom = [ self.packages.${system}.fantasy_borders ];
      };
    });
  };
}
