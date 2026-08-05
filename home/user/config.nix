{ hostname, ... }:
let configDir = ../config;
in
{
  home.file = {
      ".config/nvim".source = "${configDir}/nvim";
      ".config/wallpapers".source = "${configDir}/wallpapers";
      # ".config/kitty".source = "${configDir}/kitty";
      # ".config/neofetch".source = "${configDir}/neofetch";
      ".config/hypr" = { source = "${configDir}/hypr"; recursive = true; };
      ".config/hypr/hyprland-local.conf".source =
        if hostname == "rog"
        then "${configDir}/hypr/hyprland-rog.conf"
        else "${configDir}/hypr/hyprland-hpenvy.conf";
      ".config/waybar".source = "${configDir}/waybar";
      ".config/btop".source = "${configDir}/btop";
      ".config/mako".source = "${configDir}/mako";
      ".config/rofi".source = "${configDir}/rofi";
      ".config/fastfetch".source = "${configDir}/fastfetch";
  };
}
