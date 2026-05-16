{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/da5ad661ba4e5ef59ba743f0d112cbc30e474f32";

  outputs = { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      tailwindBin = "_build/tailwind-linux-x64";
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        packages = with pkgs; [ elixir erlang tailwindcss_4 ];

        # The Hex `tailwind` package downloads a dynamically-linked Linux
        # binary that NixOS can't run as-is. Shim its expected path to the
        # statically-linked tailwindcss from nixpkgs instead.
        shellHook = ''
          mkdir -p _build
          ln -sf ${pkgs.tailwindcss_4}/bin/tailwindcss ${tailwindBin}
        '';
      };
    };
}
