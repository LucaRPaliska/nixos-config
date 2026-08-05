{ config, pkgs, home-manager, ... }:

{
  home.packages = with pkgs; [
    kitty # Terminal
    oh-my-zsh # Zsh shell theme and plugin manager
    zsh-powerlevel10k # Neat theme for zsh
    rofi # another app launcher 
    hyprlock # Lock screen
    hypridle # Idle daemon (required for idle_inhibitor in waybar to work)
    grim # Utility that takes a screenshot for lock screen
    corrupter # Image corrupter effect for lock screen
    yazi # CLI with vim motions based file explorer
    vlc # media player
    playerctl # media player controller (media keys)
    # thunar managed via programs.thunar in system/configuration.nix
    waybar # Top status bar
    eza # Modern look for ls (replaced with alias)
    zoxide # Faster and smarter replacement for cd
    bzmenu # Bluetooth GUI
    bluez # Bluetooth protocol stack for bzmenu
    networkmanagerapplet # for GUI on network manager
    mako # Notification daemon
    libnotify # mako dependancy
    swww # wallpaper shtuff
    socat # IPC socket listener (wallpaper_manager.sh)
    btop # Resource monitor
    fastfetch # System information tool
    ncdu # Disk usage analyzer
    parted # Partition manager
    jmtpfs # FUSE filesystem for MTP devices
    pavucontrol # Audio control GUI
    xdg-utils # xdg-open and friends
    wl-clipboard # Wayland clipboard (keeps contents alive after app closes)
    cliphist # Clipboard history manager
    mpv # Video player
    zathura # PDF viewer
    hyprsunset # Blue light filter
    file-roller # Archive GUI (pairs with thunar-archive-plugin)
    kdePackages.kdenlive # Simple video editor

    # Apps
    neovim
    luajitPackages.luarocks_bootstrap # nvim dependency
    tmux
    lua
    # vivaldi # removing vivaldi in favor of brave
    brave
    google-chrome
    vesktop # Discord client with Vencord built in
    slack
    spotify
    obsidian
    zotero
    flameshot # screenshot utility
    wineWowPackages.stable
    winetricks
    audacity
    portaudio
    imagemagick # image editing terminal util
    playerctl # media player controller (media keys)
    obs-studio

    # Dev Stuff
    arduino
    fbcat # Remove ltr
    mkcert # EZ locally trusted development certs
    nodejs_24
    conda # Manages Python as a shell. Python and NixOS don't mix well.
    (python3.withPackages (ps: with ps; [
      pip
    ]))
    jq # Json CLI parser
    claude-code # gibidy
    claude-monitor # gibidy baby monitor
    opencode # gibidy 2
    code-cursor # gibidy 3
    texliveFull # LaTeX compiler tool
    gcc
    cargo # Rust package manager + compiler
    # androidsdk
    # android-studio-full # For andriod app emulator
    glib # C library of programming buildings blocks (gio for copying from MTP drives)

    # LSP Servers
    lua-language-server
    basedpyright
    typescript-language-server
    vscode-css-languageserver
    superhtml
    rust-analyzer
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Graphite-Dark";
      package = pkgs.graphite-gtk-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;

    gtk.enable = true;
    #x11.enable = true;
  };

  # Allows home-manager to install and manage itself.
  programs.home-manager = {
    enable = true;
  };

  programs.hyprlock.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "LucaRPaliska";
        email = "lucarpaliska@gmail.com";
      };
      # commit.gpgsign = true;
      # user.signingkey = "<key>";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.kitty = {
    enable = true;
    extraConfig = ''
      cursor_trail 1
      cursor_trail_decay 0.2 0.3
      cursor_trail_start_threshold 3
      background_opacity 0.5
      background_blur 1
      dynamic_background_opacity yes
    '';
  };

  programs.waybar = {
    enable = true;
  };

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledTrayIcon = true;
        copyPathAfterSave = true;
        startupLaunch = true;
        showDesktopNotification = false;
      };
    };
  };

  # Brave creates a SingletonLock file in its profile directory. If Brave is still
  # running when the machine shuts down, this lock file persists on disk and prevents
  # Brave from opening on the other machine (rog/hpenvy) until it is manually removed.
  # This service ensures Brave quits cleanly before the system powers off.
  systemd.user.services.brave-quit-on-shutdown = {
    Unit = {
      Description = "Quit Brave before shutdown";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${pkgs.coreutils}/bin/true";
      ExecStop = "-${pkgs.procps}/bin/pkill -SIGTERM brave";
      TimeoutStopSec = 5;
    };
  };
}
