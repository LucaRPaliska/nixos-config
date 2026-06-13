{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "rog";

  # NVIDIA drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;  # required for Wayland
    open = false;               # use proprietary driver (GTX 1080 not supported by open)
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.graphics.enable = true;

  # NVIDIA + Wayland env vars (applied system-wide for all sessions)
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME           = "nvidia";
    GBM_BACKEND                 = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME   = "nvidia";
    NVD_BACKEND                 = "direct";
    WLR_NO_HARDWARE_CURSORS     = "1";
  };
}
