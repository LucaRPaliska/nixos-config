{ config, pkgs, ... }:

{
  imports =
    [
      ./modules
    ];

  environment.systemPackages = with pkgs; [
    docker_29
    vim
    wget
    polkit_gnome
    gnumake
    git
    libnotify # Notification CLI tools
    gh # Github Auth
    unzip
    zip
    ripgrep # Regex pattern searcher (Nvim telescope)
    tree # CLI directory display
    htop-vim
    brightnessctl
    zsh # New shell
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  programs.ssh.extraConfig = ''
    Host listport-hetzner
      HostName 5.78.197.197
      User root
      IdentityFile /home/listport/.ssh/id_ed25519
    Host nanoclaw-hetzner
      HostName 5.78.197.197
      User nanoclaw
      IdentityFile /home/listport/.ssh/id_ed25519
  '';

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

  services.tailscale.enable = true;

  hardware.bluetooth.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.iosevka
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_zenhei
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" "Noto Serif CJK SC" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "Noto Sans Mono" "Noto Sans Mono CJK SC" ];
      };
    };
  };

  fonts.fontconfig.enable = true;

  users.users.listport = {
    isNormalUser = true;
    description = "Luca P";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  services.gvfs.enable = true; # Virtual filesystem for Thunar (trash, USB mounting, MTP)

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-volman          # Auto-mount removable drives
      thunar-archive-plugin  # Right-click archive extraction
    ];
  };

  systemSettings.brave.enable = true;

  system.stateVersion = "25.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];



  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = {};

  # Screensharing on Wayland
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig = {
      "51-bluez-config" = {
        "monitor.bluez.properties" = {
          "bluez5.codecs" = [ "aac" "sbc" "sbc_xq" ];
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
        };
      };
    };
  };
}
