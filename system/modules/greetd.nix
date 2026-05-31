{ pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland --time --remember --asterisks --theme 'border=white;text=white;prompt=white;time=white;action=white;button=white;container=reset;input=white'";
      };
    };
  };
}
