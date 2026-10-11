{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  dbus,
  libGL,
  vulkan-loader,
  wayland,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
}:
let
  # winit/wgpu dlopen these when the window opens, and the apps' own start-up
  # check reads ldconfig + LD_LIBRARY_PATH, so they go on LD_LIBRARY_PATH.
  runtimeLibs = [
    dbus
    libGL
    vulkan-loader
    wayland
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
  ];

  mkCraft =
    {
      pname,
      version,
      description,
      hashes,
      wrapperArgs ? [ ],
    }:
    let
      # upstream names its assets after the cpu, not the nix system
      arch = stdenv.hostPlatform.parsed.cpu.name;
      basename = "${pname}-${version}-linux-${arch}";
    in
    stdenv.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://github.com/storytold/${pname}/releases/download/v${version}/${basename}.tar.gz";
        hash = hashes.${stdenv.hostPlatform.system};
      };
      sourceRoot = basename;

      nativeBuildInputs = [
        autoPatchelfHook
        makeWrapper
      ];
      buildInputs = [
        stdenv.cc.cc.lib
        alsa-lib
      ];

      dontConfigure = true;
      dontBuild = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 -t $out/bin bin/*
        cp -r share $out/share
        for bin in $out/bin/*; do
          wrapProgram "$bin" --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} ${lib.escapeShellArgs wrapperArgs}
        done
        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://github.com/storytold/${pname}";
        license = with lib.licenses; [
          mit
          asl20
        ];
        sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
        platforms = [
          "aarch64-linux"
          "x86_64-linux"
        ];
        mainProgram = pname;
      };
    };
in
{
  photocraft = mkCraft {
    pname = "photocraft";
    version = "0.7.0";
    description = "Image editor with layers, masks, type and PSD support (ArtCraft)";
    hashes = {
      aarch64-linux = "sha256-hUDrHbgMrUpaV85UoMhmEW2qADYSpELpQ4LEIqCy/ak=";
      x86_64-linux = "sha256-ZB+DElL9MbQ+4aEuVy10QuVlLC5b9iPeCFdBw3DwyR0=";
    };
  };

  pdfcraft = mkCraft {
    pname = "pdfcraft";
    version = "0.6.0";
    description = "PDF workbench: read, organize, combine, split, secure (ArtCraft)";
    hashes = {
      aarch64-linux = "sha256-IPtRddtcmSNVtvHHPMWxY74F0vTycK/vahhLuuOzilk=";
      x86_64-linux = "sha256-mhNuceN7RZ7VdG2+GaNkzoTPXZlcb2yYr2FH2Bg5ClM=";
    };
  };

  wordcraft = mkCraft {
    pname = "wordcraft";
    version = "0.5.0";
    description = "Word processor with .docx support (ArtCraft)";
    hashes = {
      aarch64-linux = "sha256-wUSW0At/mkv2WEU6X56sxpFB3MSfJjEDX9mEzvyQy/M=";
      x86_64-linux = "sha256-mUuzdkee9tdnNc9AKeXvPC1SqFpMms3is3wzsZxXAgM=";
    };
  };

  deckcraft = mkCraft {
    pname = "deckcraft";
    version = "0.5.0";
    description = "Presentations and slide shows with .pptx support (ArtCraft)";
    # upstream forces the X11 backend whenever DISPLAY is set; the var flips it to native Wayland
    wrapperArgs = [
      "--set-default"
      "DECKCRAFT_WAYLAND"
      "1"
    ];
    hashes = {
      aarch64-linux = "sha256-n7Q67bmyI89i800rUJAMYzenzVyzF4ubUwu5OiE8QC0=";
      x86_64-linux = "sha256-wmSMYHH2MezGY5zmt9YPaO7YPd6rprFVmwfFBGhjEXw=";
    };
  };

  gridcraft = mkCraft {
    pname = "gridcraft";
    version = "0.5.0";
    description = "Spreadsheet with .xlsx support (ArtCraft)";
    hashes = {
      aarch64-linux = "sha256-1fOgyopPvYc3QL8SNFFVU1bKgxDw/WZwcpmNvPc6Jo8=";
      x86_64-linux = "sha256-5lBcL5KfmFTDUKDfJhicTlbIrfh8xhYl+A1qjuwrYo0=";
    };
  };
}
