{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "jams";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-JgsZIvD6wLMNgvdQ4LHSQJBQcNtOUAtS76jzICQJ0P4=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    pandas
    jsonschema
    sortedcontainers
    decorator
    mir-eval
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "jams" ];

  meta = with lib; {
    description = "A JSON Annotated Music Specification for Reproducible MIR Research";
    homepage = "https://pypi.org/project/jams/";
    license = licenses.isc;
    maintainers = with maintainers; [ carlthome ];
  };
})
