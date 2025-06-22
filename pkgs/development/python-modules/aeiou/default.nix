{
  lib,
  python3,
  fetchPypi,
  pedalboard,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aeiou";
  version = "0.0.20";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nGHJ3wOHfXhQkTdc+DsB1F2VPk+kZuuhpiUpAaUBC00=";
  };

  postPatch = ''
    substituteInPlace settings.ini \
      --replace-fail 'soundfile<=0.10.2' 'soundfile' \
      --replace-fail 'librosa>=0.8.1' 'librosa' \
  '';

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies =
    with python3.pkgs;
    [
      accelerate
      bokeh
      einops
      fastcore
      holoviews
      ipython
      librosa
      matplotlib
      numpy
      pandas
      pedalboard
      pillow
      plotly
      scipy
      soundfile
      torch
      torchaudio
      torchvision
      tqdm
      wandb
      webdataset
    ]
    ++ lib.optionals (pkgs.stdenv.system != "aarch64-linux") [
      umap-learn
    ];

  passthru.optional-dependencies = with python3.pkgs; {
    dev = [
      nbformat
    ];
  };

  pythonImportsCheck = [ "aeiou" ];

  meta = with lib; {
    description = "Audio engineering i/o utils";
    homepage = "https://pypi.org/project/aeiou/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    mainProgram = "aeiou";
  };
}
