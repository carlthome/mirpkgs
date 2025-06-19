{
  lib,
  python3,
  fetchFromGitHub,
  lame,
}:

let
  lameStatic = lame.overrideAttrs (old: {
    configureFlags = (old.configureFlags or [ ]) ++ [
      "--enable-static"
      "--disable-shared"
    ];
  });
in

python3.pkgs.buildPythonPackage rec {
  pname = "lameenc";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chrisstaite";
    repo = "lameenc";
    rev = "v${version}";
    name = pname;
    hash = "sha256-/GV18mPcru1raFfFQGSAHgNwpmwN4oVFKcBL4JjZkC8=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
    wheel
  ];

  pypaBuildFlags = [
    "-C=--build-option=--libdir=${lameStatic.lib}/lib"
    "-C=--build-option=--incdir=${lameStatic}/include/lame"
  ];

  dependencies = [ lameStatic ];

  pythonImportsCheck = [ "lameenc" ];

  meta = with lib; {
    description = "Python bindings around the LAME encoder";
    homepage = "https://github.com/chrisstaite/lameenc";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ carlthome ];
  };
}
