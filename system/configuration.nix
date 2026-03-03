{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules
    ];

  environment.systemPackages = with pkgs; [
    vim 
    wget
    gnumake
    git
    libnotify # Notification CLI tools
    gh # Github Auth
    unzip
    ripgrep # Regex pattern searcher (Nvim telescope)
    tree # CLI directory display
    htop-vim
    jq # Random data parser
    bc # Random math engine
    brightnessctl

    zsh # new shell
  ];

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

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
    # packages = with pkgs; [];
    shell = pkgs.zsh;
  };

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
