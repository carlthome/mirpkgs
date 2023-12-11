{ lib
, python3
, fetchPypi
, ffmpeg
}:

python3.pkgs.buildPythonPackage rec {
  pname = "stempeg";
  version = "0.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hAu4JFBNcTM22mqJ1ieQ97oXKgmdyW+KK7XTIUjRqWo=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    ffmpeg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    ffmpeg-python
    ffmpeg
    numpy
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    tests = [
      pytest
    ];
  };

  pythonImportsCheck = [ "stempeg" ];

  meta = with lib; {
    description = "Read and write stem/multistream audio files";
    homepage = "https://pypi.org/project/stempeg/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ carlthome ];
  };
}
