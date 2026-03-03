{
  imports = [
    ./config.nix
    ./programs.nix
    ./shell.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);

      # permittedInsecurePackages = [];
    };
  };
}
