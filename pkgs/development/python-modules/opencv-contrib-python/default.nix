{
  lib,
  python3,
  fetchPypi,
  opencl-headers,
  ninja,
  lapack,
  openblas,
  openjpeg,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opencv-contrib-python";
  version = "4.12.0.88";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Dx4igjqs4JBnuaDo4rS6bXoe8IgH1s6+oxXzEz9Bmg4=";
  };

  build-system = with python3.pkgs; [
    cmake
    numpy
    pip
    scikit-build
    setuptools
    wheel

    #opencv4
    #opencl-headers
    #ninja
    #lapack
    #openblas
    #openjpeg
  ];

  dontUseCmakeConfigure = true;

  #ENABLE_CONTRIB = 1;
  #CMAKE_ARGS = "-DCMAKE_VERBOSE_MAKEFILE=ON";
  #VERBOSE = 1;

  # Take latest packages by default.
  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "==" ">="
    substituteInPlace pyproject.toml --replace-fail "setuptools<70.0.0;" "setuptools;"
  '';

  dependencies = with python3.pkgs; [
    numpy
  ];

  pythonImportsCheck = [ "opencv_contrib_python" ];

  meta = with lib; {
    description = "Wrapper package for OpenCV python bindings";
    homepage = "https://pypi.org/project/opencv-contrib-python/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ carlthome ];
    mainProgram = "opencv-contrib-python";
  };
}
