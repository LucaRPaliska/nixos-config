{ config, pkgs, home-manager, ... }:

{
  home.packages = with pkgs; [
    kitty # Terminal
    oh-my-zsh # Zsh shell theme and plugin manager
    zsh-powerlevel10k # Neat theme for zsh
    # wofi # app launcher (wofi? bmenu? fuzzel? tofi?
    rofi # another app launcher (portentially switch out either wofi or rofi)
    hyprlock # Lock screen
    hypridle # Idle daemon (required for idle_inhibitor in waybar to work)
    grim # Utility that takes a screenshot for lock screen
    corrupter # Image corrupter effect for lock screen
    yazi # CLI with vim motions based file explorer
    nemo # GUI file explorer with ssh capabilities by Cinnamon
    # LP - add nemo to SUPER + E and also change theme to match compooper
    waybar # Top status bar # LP - eww <-- look into
    eza # Modern look for ls (replaced with alias)
    zoxide # Faster and smarter replacement for cd
    bzmenu # Bluetooth GUI
    bluez # Bluetooth protocol stack for bzmenu
    networkmanagerapplet # for GUI on network manager
    mako # Notification daemon <-- look into for more customization
    libnotify # mako dependancy
    swww # wallpaper shtuff
    btop # Resource monitor
    fastfetch # System information tool
    ncdu # Disk usage analyzer

    # Apps
    neovim
    luajitPackages.luarocks_bootstrap # nvim dependency <-- maybe look into moving this to home manager or moving nvim to system pkgs. Also, probably not needed in long-run if no plugins use this
    tmux
    lua
    vivaldi
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
    imagemagick # image editing terminal util

    # Dev Stuff
    nodejs_24
    conda # Manages Python as a shell. Python and NixOS don't mix well.
    (python3.withPackages (ps: with ps; [
      pip
    ]))
    jq # Json CLI parser
    claude-code # gibidy
    claude-monitor # gibidy baby monitor
    code-cursor # gibidy 2
    texliveFull # LaTeX compiler tool
    gcc

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
    iconTheme = {
      name = "Papirus";
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

  # LP - look into potentially using sops to encrypt keys
  programs.git.settings = {
    userName = "LucaRPaliska";
    userEmail = "lucarpaliska@gmail.com";
    # signing = {
    #   key = "<key>";
    #   signByDefault = true;
    # };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.kitty = {
    enable = true; 
    # LP - move the extraConfig to dedicated file
    extraConfig = ''
      cursor_trail 1
      cursor_train_decay 0.2
      cursor_trail_start_threshold 3
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
}
