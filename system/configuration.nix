{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # LP - look into
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
  ];

  fonts.fontconfig.enable = true;

  users.users.listport = {
    isNormalUser = true;
    description = "Luca P";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim 
    wget
    gnumake
    git
    mako # Notification daemon <-- look into for more customization
    libnotify # mako dependancy
    wofi # app launcher (wofi? bmenu? fuzzel? tofi?
    rofi # another app launcher (portentially switch out either wofi or rofi)
    networkmanagerapplet # for GUI on network manager
    swww # wallpaper shtuff
    brave # browser
    discord
    zsh # new shell
    lua # also for nvim. might need to downgrade to 5.1 but double check 
    psmisc # provides killall command which makes toggleable apps via keybind easy
    luajitPackages.luarocks_bootstrap # nvim dependency <-- maybe look into moving this to home manager or moving nvim to system pkgs. Also, probably not needed in long-run if no plugins use this
  ];

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  xdg.portal.enable = true; # LP - look into and compare to other nixos configs
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  
  security.rtkit.enable = true; # <------- see what this does?
  # security.pam.services.gtklock = {}; # gtk lock config LP - see if need to move this somewhere
  security.pam.services.hyprlock = {}; # gtk lock config LP - see if need to move this somewhere

  # Screensharing on Wayland
  services.pipewire = { 
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
