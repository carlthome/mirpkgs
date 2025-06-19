{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "submitit";
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-J2aGjnFlax4nikLzO87XT66/LFJdunT0zEO+jL72xYg=";
  };

  build-system = with python3.pkgs; [
    flit-core
  ];

  dependencies = with python3.pkgs; [
    cloudpickle
    typing-extensions
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      black
      coverage
      flit
      isort
      mypy
      pre-commit
      pylint
      pytest
      pytest-asyncio
      pytest-cov
      types-pkg-resources
    ];
  };

  pythonImportsCheck = [ "submitit" ];

  meta = with lib; {
    description = "Python 3.8+ toolbox for submitting jobs to Slurm";
    homepage = "https://pypi.org/project/submitit/";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
}
