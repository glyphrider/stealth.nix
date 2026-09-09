{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      url = "github:glyphrider/kickstart.nvim";
      flake = false;
    };
    nur.url = "github:nix-community/NUR";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nvim-config,
      hyprland,
      hyprpaper,
      nur,
      ...
    }@inputs:
    {
      nixosConfigurations.stealth = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          { nixpkgs.overlays = [ nur.overlays.default ]; }
          home-manager.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.brian = import ./home.nix;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
}
