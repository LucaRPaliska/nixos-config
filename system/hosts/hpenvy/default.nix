{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "hpenvy";
  powerManagement.cpuFreqGovernor = "schedutil";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
