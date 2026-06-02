{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "blackbird-gtk-theme";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "shimmerproject";
    repo = "Blackbird";
    rev = "a1c5674c0ec38b4cc8ba41d2c0e6187987ae7eb4";
    sha256 = "0xskcw36ci2ykra5gir5pkrawh2qkcv18p4fp2kxivssbd20d4jw";
  };

  installPhase = ''
    mkdir -p $out/share/themes/Blackbird
    cp -r gtk-2.0 gtk-3.0 gtk-3.18 gtk-3.20 index.theme metacity-1 xfwm4 $out/share/themes/Blackbird/
  '';
}
