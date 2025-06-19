{
  lib,
  python3,
  fetchFromGitHub,
  lame,
  cmake,
  stdenv,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "lameenc";
  version = "1.6.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "chrisstaite";
    repo = "lameenc";
    rev = "v${version}";
    hash = "sha256-+EnJ4v6Ol5tnFKpFCx8w1Bhu5NsaIK1OX/sjEhnMHL8=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
    cmake
    pipInstallHook
  ];

  dependencies = [ lame ];

  cmakeFlags = [
    "-DCMAKE_OSX_ARCHITECTURES=${stdenv.hostPlatform.darwinArch}"
  ];

  installPhase = ''
    mkdir -p dist
    cp *.whl dist
    pipInstallPhase
  '';

  pythonImportsCheck = [ "lameenc" ];

  meta = with lib; {
    description = "Python bindings around the LAME encoder";
    homepage = "https://github.com/chrisstaite/lameenc";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
