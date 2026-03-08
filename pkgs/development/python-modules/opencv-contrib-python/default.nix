{
  lib,
  stdenv,
  autoPatchelfHook,
  python3,
  fetchurl,
  zlib,
}:

let
  wheels = {
    "x86_64-linux" = {
      url = "https://files.pythonhosted.org/packages/b3/17/bfe5ccbaa3b15b8af3371137732e69a4563ee1b05a17e6578521c09d2a56/opencv_contrib_python_headless-4.12.0.88-cp37-abi3-manylinux2014_x86_64.manylinux_2_17_x86_64.whl";
      hash = "sha256-sYPiMiRoydO9nKxLpEsnLYKOwihCOVvPpR3zF2UiTAo=";
    };
    "aarch64-linux" = {
      url = "https://files.pythonhosted.org/packages/93/b4/13f1370c2b8e566f9c9f3658982ecd331c666215e7f379e8b1d7ab52a63d/opencv_contrib_python_headless-4.12.0.88-cp37-abi3-manylinux2014_aarch64.manylinux_2_17_aarch64.whl";
      hash = "sha256-1goSuRXFWlBGjAE/zYOelBtJzMHze5FLYlQzgsNr+B0=";
    };
    "x86_64-darwin" = {
      url = "https://files.pythonhosted.org/packages/ca/0b/abacf0a9d3161cf15ee9783fab7081f1349e825844b03178bfe6fb484e96/opencv_contrib_python_headless-4.12.0.88-cp37-abi3-macosx_13_0_x86_64.whl";
      hash = "sha256-hbUg5ScFKoWmgvCc3BLl8Vb1bYwncmG0tltIQxq66W8=";
    };
    "aarch64-darwin" = {
      url = "https://files.pythonhosted.org/packages/33/3a/edf7380db58557cc29bdcff71862b8100c64adf489517ec7250509df4b72/opencv_contrib_python_headless-4.12.0.88-cp37-abi3-macosx_13_0_arm64.whl";
      hash = "sha256-oX67kU8wmv5yRHwzuRh/8C8j8Ug/qlwP/eeq3IhxHio=";
    };
  };
in

python3.pkgs.buildPythonPackage rec {
  pname = "opencv-contrib-python";
  version = "4.12.0.88";
  format = "wheel";

  src = fetchurl (wheels.${stdenv.system} or (throw "unsupported system: ${stdenv.system}"));

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [
    stdenv.cc.cc.lib
    zlib
  ];

  preFixup = lib.optionalString stdenv.isLinux ''
    addAutoPatchelfSearchPath "$out"/lib/python*/site-packages/opencv_contrib_python_headless.libs
  '';

  dependencies = with python3.pkgs; [
    numpy
  ];

  pythonImportsCheck = [ "cv2" ];

  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings (headless)";
    homepage = "https://pypi.org/project/opencv-contrib-python-headless/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ carlthome ];
  };
}
