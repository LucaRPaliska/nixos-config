{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];
}

