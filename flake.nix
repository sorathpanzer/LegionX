{
  description = "Fear is a deadly weapon!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
            # url = "github:nix-community/home-manager";
            url = "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
            inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, ... }: 
  let
    unstable = import inputs.nixpkgs-unstable { inherit system; };
    
    system = "x86_64-linux";
    
    pkgs = import nixpkgs {
       inherit pkgs;
       config.allowUnfree = false;
     };
    
    lib = nixpkgs.lib;
  in {

  nixosConfigurations = {
      LegionX = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
           { _module.args.inputs = inputs; }
          ./system/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager = { 
              useGlobalPkgs = true;
              useUserPackages = true;
              users.sorath = import ./users/home.nix;
              extraSpecialArgs = {
                inherit unstable;
              };
            };  
          }
        ];
      };
    };

  # homeConfigurations.sorath = home-manager.lib.homeManagerConfiguration {
  #   inherit system;
  #   modules = [
  #     ./users/home.nix
  #     {
  #       home = {
  #         username = "sorath";
  #         homeDirectory = "/home/sorath";
  #         stateVersion = "23.05";
  #       };
  #     }
  #   ];
  #   extraSpecialArgs = {
  #     inherit unstable;
  #   };
  # };
    
  };  
}
