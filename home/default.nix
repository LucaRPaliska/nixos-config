{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./user
  ];
  
  home.username = "listport";
  home.homeDirectory = "/home/listport";
  home.stateVersion = "25.11";
}
