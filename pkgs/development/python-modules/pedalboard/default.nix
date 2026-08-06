{
  pkgs,
  stdenv,
  lib,
  fetchPypi,
  fetchFromGitHub,
  python3Packages,
  gcc,
  juce,
  pcre,
  pkg-config,
  python3,
  fetchgit,
  libcxx,
}:

let
  # Pedalboard still assumes JUCE 6.
  juce6 = juce.overrideAttrs (attrs: {
    version = "6.1.4";
    src = fetchFromGitHub {
      owner = "juce-framework";
      repo = "juce";
      rev = "ddaa09110392a4419fecbb6d3022bede89b7e841";
      hash = "sha256-XXG5BHLjYHFX4SE+GR0p+4p3lpvQZVRyUv080eRmvtA=";
    };
    nativeInstallCheckInputs = [ ];
    patches = [ ];
    # JUCE 6.1.4 predates newer libstdc++ header hygiene; force-include the
    # headers it relies on transitively (e.g. std::exchange from <utility>).
    # Scope this to C++ via CXXFLAGS (CMAKE_CXX_FLAGS) so CMake's C compiler
    # ABI check isn't fed C++-only headers.
    env = (attrs.env or { }) // {
      CXXFLAGS = "${attrs.env.CXXFLAGS or ""} -include cstdint -include utility";
    };
  });
in
python3.pkgs.buildPythonPackage rec {
  pname = "pedalboard";
  version = "0.8.3";
  pyproject = true;

  NIX_CFLAGS_COMPILE =
    lib.optionals stdenv.isDarwin [
      "-I${lib.getDev libcxx}/include/c++/v1"
      "-I${juce6}/share/juce/modules"
      "-I${juce6}/share/juce/modules/juce_audio_processors/format_types/VST3_SDK"
    ]
    # pedalboard vendors old C (e.g. LAME) that predates GCC 14, which promotes
    # these legacy warnings to errors by default. Downgrade them back to
    # warnings. These options are C-only; g++ ignores them harmlessly.
    ++ lib.optionals stdenv.isLinux [
      "-Wno-error=incompatible-pointer-types"
      "-Wno-error=implicit-function-declaration"
      "-Wno-error=int-conversion"
    ];

  src = fetchgit {
    url = "https://github.com/spotify/pedalboard.git";
    rev = "v${version}";
    hash = "sha256-kp2PJ3dadfbsxtAogYnwc0dzfEbmET/tIUP0M9B0Udg=";
    fetchSubmodules = true;
  };

  # JUCE 6.1.4 uses std::exchange without including <utility>, which no longer
  # compiles on modern GCC. Prepend the include to pedalboard's JUCE unity
  # translation units. A compiler force-include can't be used here because
  # setup.py also compiles C sources, which reject the C++-only header.
  postPatch = ''
    for f in pedalboard/juce_overrides/include_juce_*.cpp; do
      sed -i -e '1i #include <cstdint>' -e '1i #include <utility>' "$f"
    done
  '';

  # pedalboard's setup.py shells out to pkg-config to locate dependencies.
  nativeBuildInputs = [ pkg-config ];

  # pedalboard compiles its vendored JUCE sources, which pull in juce_gui_basics
  # and therefore need the X11/freetype/ALSA system libraries on Linux.
  buildInputs = lib.optionals stdenv.isLinux (
    with pkgs;
    [
      xorg.libX11
      xorg.libXext
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXrender
      freetype
      alsa-lib
      curl
    ]
  );

  build-system = with python3.pkgs; [
    setuptools
    wheel
    pybind11
    juce6
    pcre
  ];

  dependencies = with python3.pkgs; [
    numpy
    setuptools
    wheel
    pybind11
    juce6
  ];

  meta = with lib; {
    description = "A Python library for working with audio";
    homepage = "https://github.com/spotify/pedalboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ carlthome ];
    mainProgram = "pedalboard";
  };
}
