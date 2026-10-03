{ ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "hpenvy";
  powerManagement.cpuFreqGovernor = "schedutil";

  # amd_sfh's resume handler polls sensor-fusion firmware that never answers,
  # burning a flat 10s in dpm_resume on every wake. It only backs an unused
  # ambient-light + accelerometer pair, so drop the module entirely.
  boot.blacklistedKernelModules = [ "amd_sfh" ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
}
