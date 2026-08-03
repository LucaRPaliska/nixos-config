{ config, pkgs, ... }:

let
  configDir = ./config;
in
{
  imports = [
    ./user/shell.nix
  ];

  home.username = "listport";
  home.homeDirectory = "/home/listport";
  home.stateVersion = "25.11";

  # Only symlink configs that make sense on a headless server
  home.file = {
    ".config/nvim".source = "${configDir}/nvim";
    ".config/btop".source = "${configDir}/btop";
    ".config/fastfetch".source = "${configDir}/fastfetch";
  };

  home.packages = with pkgs; [
    # Editors & tools
    neovim
    tmux
    lua
    luajitPackages.luarocks_bootstrap

    # CLI utilities
    yazi
    eza
    btop
    fastfetch
    jq
    ncdu

    # Dev tools
    claude-code
    nodejs_24
    (python3.withPackages (ps: with ps; [ pip ]))
    gcc
    cargo

    # LSP servers (for neovim)
    lua-language-server
    basedpyright
    typescript-language-server
    rust-analyzer
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user = {
      name = "LucaRPaliska";
      email = "lucarpaliska@gmail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };
}
