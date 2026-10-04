{ config, lib, pkgs, home-manager, ... }:
let 
  myAliases = {
    ls = "eza --icons=always";

    fullClean = '' 
        nix-collect-garbage --delete-old

        sudo nix-collect-garbage -d

        sudo /run/current-system/bin/switch-to-configuration boot
    '';
    rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
    fullRebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/ && home-manager switch --flake ~/.dotfiles/ -b backup";
    homeRebuild = "home-manager switch --flake ~/.dotfiles/ -b backup";
};
in
{
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # Draws a prompt from cache in ~10ms and buffers keystrokes while the
        # rest of this file loads. Must stay before anything that writes to stdout.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Skips compaudit, which only flags root-owned /nix/store completion dirs.
        ZSH_DISABLE_COMPFIX=true
      '')
      ''
        source ~/.p10k.zsh
      ''
    ];
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    shellAliases = myAliases;
    oh-my-zsh = {
      enable = true;
      # custom = "$HOME/.oh-my-custom";
      # theme = "powerlevel10k/powerlevel10k";
      # theme = "robbyrussell";
      plugins = [
	"git"
	"history"
	"wd"
      ];
    };
  };
}
