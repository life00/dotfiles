{
  stdenv,
  autoPatchelfHook,
  zlib,
  gmp,
  quarto,
  writeText,
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
  # quarto ships a jupyter setup cell for python and julia only; for any other
  # kernel language it falls back to reading kernelspec.path, which notebooks
  # don't carry, and `quarto preview` dies with a bare "path" (KeyError)
  octaveSetupCell = writeText "setup.m" ''
    run_path = char(base64_decode('{run_path}'));
    if ~isempty(run_path), cd(run_path); end
  '';
in
(quarto.override {
  pandoc = pandocQuarto;
  inherit extraRPackages;
}).overrideAttrs
  (old: {
    postInstall = (old.postInstall or "") + ''
      install -Dm444 ${octaveSetupCell} $out/share/jupyter/lang/octave/setup.m
    '';
  })
