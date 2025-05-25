{ stdenv, lib, fetchFromGitHub, cmake, valgrind
, enableStatic ? stdenv.hostPlatform.isStatic }:

stdenv.mkDerivation rec {
  pname = "libnmea";
  version = "91fd4338a8f648de9b174d7aac954fedce8852aa";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "jacketizer";
    repo = pname;
    tag = null;
    rev = version;
    sha256 =
      lib.fakeSha256; # since the package is built of a git commit hash, we technically don't need the hash
  };

  nativeBuildInputs = [ cmake valgrind ];

  cmakeFlags = [
    "-DNMEA_BUILD_STATIC_LIB=${if enableStatic then "ON" else "OFF"}"
    "-DNMEA_BUILD_SHARED_LIB=ON"
    "-DNMEA_BUILD_EXAMPLES=OFF"
    "-DNMEA_UNIT_TESTS=ON"
    "-DNMEA_UNIT_TESTS_LINK_STATIC=${if enableStatic then "ON" else "OFF"}"
    "-DNMEA_WITH_MEMCHECK=ON"
  ];

  meta = with lib; {
    description = "Lightweight C library for parsing NMEA 0183 sentences";
    homepage = "https://github.com/jacketizer/libnmea";
    license = licenses.mit;
    maintainers = with maintainers; [ Jasper-Ben ];
    platforms = platforms.all;
  };
}
