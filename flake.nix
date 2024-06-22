{
  description = "NixOS flake with disko and impermanence for provisioning x86 machine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, disko, impermanence }: {
    nixosConfigurations = {
      x86_machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          ./configuration.nix
        ];
      };
    };
  };
}

