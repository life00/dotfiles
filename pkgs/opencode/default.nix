{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  ripgrep,
  wayland,
}:
# prebuilt bun binary, runs via nix-ld (patchelf would corrupt the appended bundle)
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "2.0.24";

  src = fetchurl {
    url = "https://registry.npmjs.org/@opencode/cli-linux-arm64/-/cli-linux-arm64-${finalAttrs.version}.tgz";
    hash = "sha512-n+C1XkoIB0NaHK9CQo4gGIc9FRGDhrMdCXO8heEOvUgKsH/0ROxCr3CxUuJaKolL/5+c5u3CoiXsckL+fa52ag==";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontStrip = true;
  dontPatchELF = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ wayland ]} \
      --set OPENCODE_DISABLE_AUTOUPDATE 1
    runHook postInstall
  '';

  meta = {
    platforms = [ "aarch64-linux" ];
    mainProgram = "opencode";
  };
})
