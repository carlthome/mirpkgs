{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "dali-dataset";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    pname = "DALI-dataset";
    inherit version;
    hash = "sha256-1PA581EiRkkgcc5w6fWQF8atZMz5+JRGY/02qcgWe3A=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    yt-dlp
    numpy
  ];

  postPatch = ''
    substituteInPlace setup.py DALI/download.py --replace-fail "youtube_dl" "yt_dlp"
  '';

  pythonImportsCheck = [ "DALI" ];

  meta = with lib; {
    description = "Code for working with the DALI dataset";
    homepage = "https://pypi.org/project/dali-dataset";
    license = with licenses; [
      # TODO cc-by-nc-sa-40
    ];
    maintainers = with maintainers; [ carlthome ];
  };
}
