{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonApplication rec {
  pname = "read-version";
  version = "0.3.2";
  format = "pyproject";

  src = fetchPypi {
    pname = "read_version";
    inherit version;
    hash = "sha256-Py0whSvOkXSyRPfymq6/TnmQTG7VGhlxYyUBX/MGzj8=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    toml = [
      toml
    ];
  };

  pythonImportsCheck = [ "read_version" ];

  meta = with lib; {
    description = "Extract your project's __version__ variable";
    homepage = "https://pypi.org/project/read-version/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
