{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  src = fetchFromGitHub {
    owner = "cesanta";
    repo = "mongoose";
    tag = "7.18";
    sha256 = "sha256-mbbeZPeUv6caYBqmrgjIlikni/pJmD9lkrc7a1qkurA=";
  };
  pname = src.repo + "-ws";
  version = src.tag;

  outputs = [ "out" ];

  configurePhase = "";

  buildPhase = "make -C $NIX_BUILD_TOP/${src.name}/test linux-libs";
  installPhase = ''
    mkdir -p $out/usr/local/lib
    DESTDIR=$out make -C $NIX_BUILD_TOP/${src.name}/test install
  '';

  meta = with lib; {
    description =
      "Embedded web server, with TCP/IP network stack, MQTT and Websocket";
    homepage = "https://mongoose.ws/";
    license = [ licenses.gpl2 licenses.unfree ] # main package is dual-licensed
      ++ [ licenses.bsd3 ]; # Findmongoose.cmake is bsd3 licensed
    maintainers = with maintainers; [ Jasper-Ben ];
    platforms = platforms.linux;
  };
}
