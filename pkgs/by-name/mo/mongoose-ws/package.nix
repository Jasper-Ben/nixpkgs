{ stdenv, lib, fetchFromGitHub }:

let
  remoteSrc = fetchFromGitHub {
    owner = "cesanta";
    repo = "mongoose";
    tag = "7.18";
    sha256 = "sha256-8EMcew47h7x3o0ZOaZhj7JsglENQ2GZrJNP1WDXfiY8=";
  };

  combinedSrc = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      (lib.fileset.fromSource remoteSrc)
      ./Findmongoose.cmake
    ];
  };

in stdenv.mkDerivation {
  pname = remoteSrc.repo ++ "-ws";
  version = remoteSrc.tag;
  src = combinedSrc;

  outputs = [ "out" "dev" ];

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = "make -C test linux-libs";

  meta = with lib; {
    description =
      "Embedded web server, with TCP/IP network stack, MQTT and Websocket";
    homepage = "https://mongoose.ws/";
    license = [ licenses.gplv2 licenses.unfree ] # main package is dual-licensed
      ++ licenses.bsd3; # Findmongoose.cmake is bsd3 licensed
    maintainers = with maintainers; [ Jasper-Ben ];
    platforms = platforms.linux;
  };
}
