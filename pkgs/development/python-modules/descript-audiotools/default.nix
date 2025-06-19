{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "descript-audiotools";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LN02MCXHcbisxT1e+ex340+S4YInLEvn/QEYqZtqXio=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    argbind
    ffmpy
    flatten-dict
    importlib-resources
    ipython
    julius
    librosa
    markdown2
    matplotlib
    numpy
    protobuf
    pyloudnorm
    pystoi
    randomname
    rich
    scipy
    soundfile
    tensorboard
    torch
    torch-stoi
    torchaudio
    tqdm
  ];

  optional-dependencies = with python3.pkgs; {
    docs = [
      myst-nb
      myst-parser
      sphinx
      sphinx-multiversion
      sphinx-rtd-theme
    ];
    tests = [
      gradio
      line-profiler
      pesq
      pytest
      pytest-cov
      transformers
    ];
    whisper = [
      transformers
    ];
  };

  pythonImportsCheck = [
    "descript_audiotools"
  ];

  meta = {
    description = "Utilities for handling audio";
    homepage = "https://pypi.org/project/descript-audiotools/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "descript-audiotools";
  };
}
