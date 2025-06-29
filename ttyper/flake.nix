{
  description = "CLI typing test";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # minttea = {
    #   url = "github:leostera/minttea";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        let
          inherit (pkgs) ocamlPackages mkShell;
          inherit (ocamlPackages) buildDunePackage;
          version = "0.0.1";
        in
        {
          devShells = {
            default = mkShell.override { stdenv = pkgs.clang17Stdenv; } {
              buildInputs = [
                ocamlPackages.utop
                pkgs.ocaml
                ocamlPackages.ocaml-lsp
              ];
              inputsFrom = [ self'.packages.default ];
            };
          };

          packages = {
            default = buildDunePackage {
              inherit version;
              pname = "ttyper";
              propagatedBuildInputs = with ocamlPackages; [
                minttea
                spices
                # inputs'.minttea.packages.default
                # inputs'.minttea.packages.spices
                # inputs'.minttea.packages.leaves
              ];
              src = ./.;
            };

          };
        };
    };
}
