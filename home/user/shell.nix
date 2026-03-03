{ config, pkgs, home-manager, ... }:
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
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initContent = '' 
          source ~/.p10k.zsh && 
          eval "$(zoxide init --cmd cd zsh)"
      ''; 
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./.; # Assumes p10k.zsh is in the same folder as this nix file
        file = "p10k.zsh";
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
