{ lib
, python3
, fetchFromGitHub
, lame
}:

python3.pkgs.buildPythonPackage rec {
  pname = "lameenc";
  version = "1.6.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "chrisstaite";
    repo = "lameenc";
    rev = "v${version}";
    hash = "sha256-+EnJ4v6Ol5tnFKpFCx8w1Bhu5NsaIK1OX/sjEhnMHL8=";
  };

  pythonImportsCheck = [ "lameenc" ];

  buildPhase = ''
    ${python3}/bin/python3 setup.py build --libdir=${lame.lib}/lib --incdir=${lame}/include/lame
  '';

  propagatedBuildInputs = [ lame ];

  meta = with lib; {
    description = "Python bindings around the LAME encoder";
    homepage = "https://github.com/chrisstaite/lameenc";
    license = with licenses; [ ];
    maintainers = with maintainers; [ carlthome ];
  };
}
