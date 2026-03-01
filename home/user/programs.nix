{ config, pkgs, home-manager, ... }:

{
  home.packages = with pkgs; [
    waybar # Top status bar # LP - eww <-- look into
    kitty # Terminal
    hyprlock # Lock screen
    grim # Screenshot for lock screen
    corrupter # Image corrupter effect for lock screen
    # nvim
    tmux # Terminal multiplexer
    bluez # Bluetooth GUI
    # mako

    # Misc
    libnotify # Notification CLI tools
    gh # Github Auth
    unzip
    ripgrep # Regex pattern searcher (Nvim telescope)

    # Dev Stuff
    nodejs_24
    python315
  ];

  home.sessionVariables = {
    # EDITOR = "emacs";
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

  programs.bash = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
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
