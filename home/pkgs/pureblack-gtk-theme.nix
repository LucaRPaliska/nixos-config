{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "pureblack-gtk-theme";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "matheusphh";
    repo = "PureBlack-gtk-theme";
    rev = "3d387b2a5d5397e97eaf974e34ca14c911c344a2";
    sha256 = "02m7cnyrns2d9681ic542jl2f9axjah2rj0j6ajfiik1h1d125qr";
  };

  installPhase = ''
    mkdir -p $out/share/themes/PureBlack
    cp -r gtk-3.0 gtk-4.0 gnome-shell $out/share/themes/PureBlack/
  '';
}
