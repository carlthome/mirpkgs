{
  lib,
  python3,
  fetchurl,
  opencv-contrib-python,
}:

python3.pkgs.buildPythonPackage rec {
  pname = "mediapipe";
  version = "0.10.32";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/e3/98/00cd8b2dcb563f2298655633e6611a791b2c1a7df1dae064b2b96084f1bf/mediapipe-0.10.32-py3-none-manylinux_2_28_x86_64.whl";
    hash = "sha256-SwlB+7vOQYYvE8sYUMSHjBPbxizV6B50iABRt6IM47Y=";
  };

  dependencies = with python3.pkgs; [
    absl-py
    flatbuffers
    numpy
    opencv-contrib-python
    sounddevice
  ];

  pythonImportsCheck = [ "mediapipe" ];

  meta = with lib; {
    description = "Cross-platform, customizable ML solutions for live and streaming media";
    homepage = "https://github.com/google/mediapipe";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mediapipe";
  };
}
