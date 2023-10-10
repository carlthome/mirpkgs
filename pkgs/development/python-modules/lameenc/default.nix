{ lib
, python3
, fetchFromGitHub
, lame
, cmake
, clang
}:

python3.pkgs.buildPythonPackage rec {
  pname = "lameenc";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisstaite";
    repo = "lameenc";
    rev = "v${version}";
    hash = "sha256-+EnJ4v6Ol5tnFKpFCx8w1Bhu5NsaIK1OX/sjEhnMHL8=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    cmake
    clang
  ];

  propagatedBuildInputs = [ lame ];

  configurePhase = ''
    cmake -S $src -B $out
  '';

  buildPhase = ''
    cd $out
    make
  '';

  pythonImportsCheck = [ "lameenc" ];

  meta = with lib; {
    description = "Python bindings around the LAME encoder";
    homepage = "https://github.com/chrisstaite/lameenc";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
