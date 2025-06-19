{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "soundcloud-lib";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hRadbn45zTntMGjr99VKGm+oZZWSA7UL1oKQdL40bmQ=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    mutagen
    beautifulsoup4
    aiohttp
  ];

  pythonImportsCheck = [ "soundcloud_lib" ];

  meta = with lib; {
    description = "Python Soundcloud API";
    homepage = "https://pypi.org/project/soundcloud-lib/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "soundcloud-lib";
  };
}
