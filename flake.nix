{
  description = "NixOS config flake";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  {
    diskoConfigurations = {
            vm.disko.devices = {
                disk = {
                    main = {
                        device = "/dev/sda";
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

