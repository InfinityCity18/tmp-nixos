{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  {
    nixosConfigurations = {
        nixosd = let 
            username = "hyperbarq";
            specialArgs = {inherit username;};
        in nixpkgs.lib.nixosSystem {
            inherit specialArgs;
            system = "x86_64-linux";

            modules = [
                home-manager.nixosModules.home-manager 
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.extraSpecialArgs = inputs // specialArgs;
                    home-manager.users.${username} = import ./users/${username}/home.nix;
                }
            ];
        };

        }
    };

    diskoConfigurations = {
            laptop.disko.devices = {
                disk = {
                    main = {
                        device = "/dev/nvme0n1";
                        type = "disk";
                        content = {
                            type = "gpt";
                            partitions = {
                                ESP = {
                                    type = "EF00";
                                    size = "1G";
                                    content = {
                                        type = "filesystem";
                                        format = "vfat";
                                        mountpoint = "/boot";
                                    };
                                };
                                root = {
                                    size = "100%";
                                    content = {
                                        type = "filesystem";
                                        format = "ext4";
                                        mountpoint = "/";
                                    };
                                };
                            };
                        };
                    };
                };
            };
    };
  };
}

