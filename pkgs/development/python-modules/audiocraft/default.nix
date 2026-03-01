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
    # Remove stale egg-info so setuptools re-reads the patched requirements.txt
    # instead of using the cached metadata with strict version pinning.
    rm -rf audiocraft.egg-info

    # Patch both requirements.txt and PKG-INFO (used by setuptools to generate
    # wheel METADATA) to remove strict version pins that conflict with nixpkgs.
    sed -i \
      -e 's/torch==2\.1\.0/torch/g' \
      -e 's/torchaudio>=2\.0\.0,<2\.1\.2/torchaudio/g' \
      -e 's/torchvision==0\.16\.0/torchvision/g' \
      -e 's/torchtext==0\.16\.0/torchtext/g' \
      -e 's/av==11\.0\.0/av/g' \
      -e 's/xformers<0\.0\.23/xformers/g' \
      requirements.txt PKG-INFO

    # Fix transformers 5.x incompatibility: top-level exports removed
    substituteInPlace audiocraft/modules/conditioners.py \
      --replace-fail \
        'from transformers import RobertaTokenizer, T5EncoderModel, T5Tokenizer  # type: ignore' \
        'from transformers.models.roberta.tokenization_roberta import RobertaTokenizer  # type: ignore
from transformers.models.t5.modeling_t5 import T5EncoderModel  # type: ignore
from transformers.models.t5.tokenization_t5 import T5Tokenizer  # type: ignore'
    substituteInPlace audiocraft/models/encodec.py \
      --replace-fail \
        'from transformers import EncodecModel as HFEncodecModel' \
        'from transformers.models.encodec.modeling_encodec import EncodecModel as HFEncodecModel'
    substituteInPlace audiocraft/metrics/clap_consistency.py \
      --replace-fail \
        'from transformers import RobertaTokenizer  # type: ignore' \
        'from transformers.models.roberta.tokenization_roberta import RobertaTokenizer  # type: ignore'
  '';

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

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

  # Skip version constraint check: requirements.txt pins are relaxed in
  # postPatch but pythonRuntimeDepsCheckHook may still read stale constraints
  # from PKG-INFO or egg-info metadata in the source distribution.
  dontCheckRuntimeDeps = true;

  pythonImportsCheck = [ "audiocraft" ];

  meta = with lib; {
    description = "Audio generation research library for PyTorch";
    homepage = "https://pypi.org/project/audiocraft/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ carlthome ];
  };
}
