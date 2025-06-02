{
  description = "Rice";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages = {
        # inherit (pkgs) flarrent;
        # default = pkgs.flarrent;
      };

      devShell = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          pkg-config
          flutter327
          inotify-tools
          lsof
          meson
          ninja
          pkg-config
          scdoc
          wayland-scanner
        ];
        buildInputs = with pkgs; [
          kdePackages.wayland.out
          libGL
          gtk-layer-shell
          cava
          pixman
          libpng
          libjpeg
          wayland
          wayland-protocols
          libepoxy
          libdrm.out
        ];
      };
    });
}
