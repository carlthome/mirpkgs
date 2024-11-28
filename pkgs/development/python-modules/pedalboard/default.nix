{ lib
, python3
, fetchgit
, fetchFromGitHub
, juce
, stdenv
, libcxx
, darwin
, pcre
, rubberband
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
  version = "0.9.12";
  #pyproject = true;

  src = fetchgit {
    url = "https://github.com/spotify/pedalboard.git";
    rev = "v${version}";
    hash = "sha256-tdnBpnHzSD7k2QIlfbtVIr7g2ZadwdXWZ2EdA4q/3H0=";
    fetchSubmodules = false;
  };

  NIX_CFLAGS_COMPILE = [
    "-I${lib.getDev libcxx}/include/c++/v1"
    "-I${juce6}/share/juce/modules"
    "-I${juce6}/share/juce/modules/juce_audio_processors/format_types/VST3_SDK"
    "-I${python3.pkgs.pybind11}/include"
    "-I${lib.getDev rubberband}/include"
  ];

  nativeBuildInputs = with python3.pkgs; [
    pybind11
    rubberband
    #setuptools
    #wheel
    #numpy
    #juce
    #pcre
  ];

  propagatedBuildInputs = with python3.pkgs; [
    numpy
  ] ++ lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    Accelerate
    AVFoundation
    # AudioToolbox
    AudioUnit
    # Carbon
    Cocoa
    #CoreAudio
    CoreAudioKit
    # CoreServices
    # DiscRecording
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
