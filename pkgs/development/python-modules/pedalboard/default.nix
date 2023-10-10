{ lib
, python3
, fetchFromGitHub
, juce
, stdenv
, libcxx
, darwin
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
  });
in
python3.pkgs.buildPythonPackage rec {
  pname = "pedalboard";
  version = "0.8.3";
  pyproject = true;

  NIX_CFLAGS_COMPILE = lib.optionals stdenv.isDarwin [
    "-I${lib.getDev libcxx}/include/c++/v1"
    "-I${juce6}/share/juce/modules"
    "-I${juce6}/share/juce/modules/juce_audio_processors/format_types/VST3_SDK"
  ];

  src = fetchFromGitHub {
    owner = "spotify";
    repo = "pedalboard";
    rev = "v${version}";
    hash = "sha256-o5kqacMYT/+oQMjxkNrfTjuGKxAZ1VFmfmk4pw71KjA=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    pybind11
    juce6
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate
    AudioToolbox
    AudioUnit
    Carbon
    Cocoa
    CoreAudio
    CoreAudioKit
    CoreServices
    DiscRecording
    MetalKit
    WebKit
  ]);

  pythonImportsCheck = [ "pedalboard" ];

  meta = with lib; {
    description = "A Python library for working with audio";
    homepage = "https://github.com/spotify/pedalboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ carlthome ];
    mainProgram = "pedalboard";
  };
}
