{
  lib,
  stdenv,
  autoPatchelfHook,
  python3,
  fetchurl,
}:

let
  wheels = {
    "x86_64-linux" = {
      url = "https://files.pythonhosted.org/packages/25/0b/672f2b0d9bf9dca56290c845a91e64969adb40eec0a8d3fc4cdf4ef3f5f1/pedalboard-0.9.22-cp313-cp313-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl";
      hash = "sha256-sAqSI/FL+zPcpD0S1/jPfZGz9SHaRTEklh2jOka3ftc=";
    };
    "aarch64-linux" = {
      url = "https://files.pythonhosted.org/packages/93/dd/7130967ed07057fdcc3ec0d468901f3567fdb016d655e398cd90d0ef9ece/pedalboard-0.9.22-cp313-cp313-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl";
      hash = "sha256-Ryq9ANlVPbUH9zgNGTYtuxChU0RRIhnC0ER7Galy1ho=";
    };
    "x86_64-darwin" = {
      url = "https://files.pythonhosted.org/packages/7a/14/4d40d257bf6f26badc20826183133f635028d9b2b6657af3a460ea63e1be/pedalboard-0.9.22-cp313-cp313-macosx_10_14_x86_64.whl";
      hash = "sha256-ABoblKmMq622l81BBUX+Ft5pSd2Au28HaK9oKDLyiHM=";
    };
    "aarch64-darwin" = {
      url = "https://files.pythonhosted.org/packages/0d/a1/4dc73328d2883fdd6f0f4ce29627bbe398a442fabee6e8f7194d83c14e33/pedalboard-0.9.22-cp313-cp313-macosx_11_0_arm64.whl";
      hash = "sha256-4G1khZCk3PKpkU+W0bGEZWiMVc6JCQa6E+1Whm9y6Ro=";
    };
  };
in

python3.pkgs.buildPythonPackage rec {
  pname = "pedalboard";
  version = "0.9.22";
  format = "wheel";

  src = fetchurl (wheels.${stdenv.system} or (throw "unsupported system: ${stdenv.system}"));

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

  dependencies = with python3.pkgs; [
    numpy
  ];

  pythonImportsCheck = [ "pedalboard" ];

  meta = with lib; {
    description = "A Python library for working with audio";
    homepage = "https://github.com/spotify/pedalboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ carlthome ];
  };
}
