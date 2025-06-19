{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "read-version";
  version = "0.3.2";
  pyproject = true;

  src = fetchPypi {
    pname = "read_version";
    inherit version;
    hash = "sha256-Py0whSvOkXSyRPfymq6/TnmQTG7VGhlxYyUBX/MGzj8=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
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
