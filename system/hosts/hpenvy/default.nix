{ ... }:

{
  imports = [ ../../hardware-configuration.nix ];

  networking.hostName = "hpenvy";
  powerManagement.cpuFreqGovernor = "schedutil";
}
