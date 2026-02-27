{
  imports = [
    ./config.nix
    ./programs.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);

      # permittedInsecurePackages = [];
    };
  };
}
