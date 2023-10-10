{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "jams";
  version = "0.3.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i7IVi9GbTwV7i5AyG0Sx3RZZxmy+vg1CGYidMdf4iLk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pandas
    jsonschema
    sortedcontainers
    decorator
    mir_eval
  ];

  checkInputs = with python3.pkgs; [
    pytest-cov
  ];

  pythonImportsCheck = [ "jams" ];

  meta = with lib; {
    description = "A JSON Annotated Music Specification for Reproducible MIR Research";
    homepage = "https://pypi.org/project/jams/";
    license = licenses.isc;
    maintainers = with maintainers; [ carlthome ];
  };
}
