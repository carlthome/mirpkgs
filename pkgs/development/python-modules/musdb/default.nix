{
  lib,
  python3,
  fetchPypi,
  stempeg,
  ffmpeg,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "musdb";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bbTV5L8myZgqk4esYX+uf8gYLASF/Em0Q3JxI96L4FM=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    ffmpeg
    pytest
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
    pyaml
    stempeg
    tqdm
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      check-manifest
    ];
    docs = [
      recommonmark
      sphinx
      sphinx-rtd-theme
    ];
    tests = [
      pytest
    ];
  };

  pythonImportsCheck = [ "musdb" ];

  meta = with lib; {
    description = "Python parser for the SIGSEP MUSDB18 dataset";
    homepage = "https://pypi.org/project/musdb/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
