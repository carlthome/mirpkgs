{
  pkgs,
  lib,
  python3,
  fetchPypi,
  demucs,
  flashy,
  hydra-colorlog,
  torchtext,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "audiocraft";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2CrePrT5NO4a20OK5oeiv1nTPKSiADm+qwclSMA4rIA=";
  };

  patches = lib.optionals pkgs.stdenv.isDarwin [
    ./remove-xformers.patch
  ];

  postPatch = ''
    substituteInPlace requirements.txt --replace-fail 'xformers<0.0.23' ' '
  '';

  dependencies =
    with python3.pkgs;
    [
      av
      demucs
      einops
      encodec
      flashy
      gradio
      huggingface-hub
      hydra-colorlog
      hydra-core
      julius
      librosa
      num2words
      numpy
      protobuf
      sentencepiece
      spacy
      torch
      torchaudio
      torchvision
      torchtext
      torchmetrics
      tqdm
      transformers
    ]
    ++ lib.optionals pkgs.stdenv.isLinux [
      xformers
    ];

  pythonImportsCheck = [ "audiocraft" ];

  meta = with lib; {
    description = "Audio generation research library for PyTorch";
    homepage = "https://pypi.org/project/audiocraft/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ carlthome ];
  };
}
