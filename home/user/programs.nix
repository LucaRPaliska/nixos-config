{ config, pkgs, home-manager, ... }:

{
  home.packages = with pkgs; [
    kitty # Terminal
    oh-my-zsh # Zsh shell theme and plugin manager
    zsh-powerlevel10k # Neat theme for zsh
    wofi # app launcher (wofi? bmenu? fuzzel? tofi?
    rofi # another app launcher (portentially switch out either wofi or rofi)
    hyprlock # Lock screen
    yazi # CLI with vim motions based file explorer
    waybar # Top status bar # LP - eww <-- look into
    eza # Modern look for ls
    zoxide # Faster and smarter replacement for cd
    grim # Screenshot for lock screen
    corrupter # Image corrupter effect for lock screen
    bluez # Bluetooth GUI
    bzmenu
    networkmanagerapplet # for GUI on network manager
    mako # Notification daemon <-- look into for more customization
    libnotify # mako dependancy
    swww # wallpaper shtuff

    # Apps
    neovim 
    tmux # Terminal multiplexer
    luajitPackages.luarocks_bootstrap # nvim dependency <-- maybe look into moving this to home manager or moving nvim to system pkgs. Also, probably not needed in long-run if no plugins use this
    lua
    vivaldi
    brave
    google-chrome
    discord
    slack
    spotify
    flameshot # screenshot utility

    # Dev Stuff
    nodejs_24
    (python3.withPackages (ps: with ps; [
      pip
    ]))
    jq

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

   # LP - see if move this
   # Needed for discord graphics to be normal qualtiy (unsure why)
  xdg.desktopEntries = {
    discord = {
      name = "Discord Custom";
      exec = "discord --disable-gpu"; #--enable-features=WaylandWindowDecorations --ozone-platform-hint=auto"; LP
      icon = "discord";
      terminal = false;
      categories = [ "Network" "InstantMessaging" ];
      mimeType = [ "x-scheme-handler/discord" ];
    };
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
}
