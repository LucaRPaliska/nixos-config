{ config, pkgs, home-manager, ... }:

{

  home.packages = with pkgs; [
    hello
    waybar # eww <-- look into
    kitty
    tmux
    ripgrep
    bluez # waybar integrated bluetooth manager w rofi
    gh # github auth
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
      cursor_train_decay 0.2
      cursor_trail_start_threshold 3
    '';
  };

  programs.waybar = {
    enable = true;
  };
}
