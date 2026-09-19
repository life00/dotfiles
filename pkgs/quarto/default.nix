{
  stdenv,
  autoPatchelfHook,
  zlib,
  gmp,
  quarto,
  extraRPackages ? [ ],
}:
let
  # nixpkgs pairs quarto with pandoc 3.7, but quarto 1.10 emits defaults keys
  # that only pandoc >=3.8 parses. reuse the pandoc its own tarball ships.
  pandocQuarto = stdenv.mkDerivation {
    pname = "pandoc-quarto";
    inherit (quarto) version src;
    sourceRoot = "quarto-${quarto.version}";
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      (stdenv.cc.cc.libgcc or null)
      zlib
      gmp
    ];
    installPhase = ''
      runHook preInstall
      install -Dm755 bin/tools/${stdenv.hostPlatform.parsed.cpu.name}/pandoc $out/bin/pandoc
      runHook postInstall
    '';
    meta.mainProgram = "pandoc";
  };
in
quarto.override {
  pandoc = pandocQuarto;
  inherit extraRPackages;
}
