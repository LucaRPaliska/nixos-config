{ ... }:

{
  # Generate with: nixos-generate-config --show-hardware-config
  # imports = [ ./hardware-configuration.nix ];

  networking.hostName = "server";

  # Open additional ports as needed
  # networking.firewall.allowedTCPPorts = [ 80 443 ];
}
