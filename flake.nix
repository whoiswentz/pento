{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/da5ad661ba4e5ef59ba743f0d112cbc30e474f32";

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [ elixir erlang ];
      };
    };
}