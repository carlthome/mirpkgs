{
  lib,
  python3,
  fetchPypi,
  mido,
}:

python3.pkgs.buildPythonPackage (finalAttrs: {
  pname = "pretty-midi";
  version = "0.2.10";
  pyproject = true;

  src = fetchPypi {
    pname = "pretty_midi";
    inherit (finalAttrs) version;
    hash = "sha256-6m4ZL5QERnToMzNuofQVMY3fKOMgMCrHsQnt/w1FNL0=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    six
    numpy
    mido
  ];

  pythonImportsCheck = [ "pretty_midi" ];

  meta = with lib; {
    description = "Functions and classes for handling MIDI data conveniently";
    homepage = "https://pypi.org/project/pretty-midi";
    license = licenses.mit;
    maintainers = with maintainers; [ carlthome ];
  };
})
