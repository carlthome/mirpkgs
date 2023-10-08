{ lib
, python3
, fetchPypi
, treetable
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dora-search";
  version = "0.1.12";
  format = "pyproject";

  src = fetchPypi {
    pname = "dora_search";
    inherit version;
    hash = "sha256-KVb9LEx+S5pIMOg/DUz5Yb5Fz7oaLwVwKB6R0VrFFvs=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    hydra-core
    pytorch-lightning
    retrying
    torch
    treetable
  ];

  pythonImportsCheck = [ "dora_search" ];

  meta = with lib; {
    description = "Easy grid searches for ML";
    homepage = "https://pypi.org/project/dora-search/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
