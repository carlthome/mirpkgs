{ lib
, python3
, fetchPypi
, mido
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pretty-midi";
  version = "0.2.10";
  format = "setuptools";

  src = fetchPypi {
    pname = "pretty_midi";
    inherit version;
    hash = "sha256-6m4ZL5QERnToMzNuofQVMY3fKOMgMCrHsQnt/w1FNL0=";
  };

  propagatedBuildInputs = with python3.pkgs; [
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
}
