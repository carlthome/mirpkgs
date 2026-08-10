{
  lib,
  stdenv,
  python3,
  fetchPypi,
  autoPatchelfHook,
  opencv-contrib-python,
}:

let
  # Upstream publishes one ABI-independent wheel per platform.
  wheels = {
    x86_64-linux = {
      platform = "manylinux_2_28_x86_64";
      hash = "sha256-B6RJRGv4iKiieH2/b8GjPaTEeXcxPe7GTRPDW/9B9tI=";
    };
    aarch64-linux = {
      platform = "manylinux_2_28_aarch64";
      hash = "sha256-5X2aYGcjssd6UbsdGUyOtzaoTFUtJFeKhTb0f2VrskE=";
    };
    aarch64-darwin = {
      platform = "macosx_11_0_arm64";
      hash = "sha256-fuR4O+QbLeNF4etx4vfnwVmlDtXCg+YMy49aYCfHCoI=";
    };
  };
  wheel =
    wheels.${stdenv.hostPlatform.system}
      or (throw "mediapipe: no wheel for ${stdenv.hostPlatform.system}");
in

python3.pkgs.buildPythonApplication rec {
  pname = "mediapipe";
  version = "1.0.0";
  format = "wheel";

  # Building from source drives Bazel, which fetches its own dependencies, so
  # take the wheel upstream already built.
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    abi = "none";
    inherit (wheel) platform hash;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  dependencies = with python3.pkgs; [
    absl-py
    certifi
    flatbuffers
    matplotlib
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
    platforms = builtins.attrNames wheels;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
