{
  stdenv,
  mindustry,
}:

let
  client = mindustry.override {
    enableServer = true;
    enableWayland = true;
  };
in
if !stdenv.hostPlatform.isAarch64 then
  client
else
  client.overrideAttrs (old: {
    pname = "mindustry-aarch64";

    # Arc declares addLinux(x64, ARM) for arc-core, freetype and filedialogs but
    # not for backend-sdl, so no aarch64 desktop natives exist upstream and
    # nixpkgs marks the client broken here. Retarget backend-sdl's sole Linux
    # target; jnigen then emits libsdl-arcarm64.so into libs/linuxarm64, which is
    # what Arc's SharedLibraryLoader.mapLibraryName looks for at runtime.
    postPatch = old.postPatch + ''
      substituteInPlace ../Arc/backends/backend-sdl/build.gradle \
        --replace-fail 'addLinux(x64, x86){' 'addLinux(x64, ARM){' \
        --replace-fail '"libs/linux64"' '"libs/linuxarm64"'
    '';

    # jnigen hardcodes compilerPrefix = "aarch64-linux-gnu-" for its Linux ARM64
    # target; the native aarch64 stdenv only ships unprefixed tools.
    preBuild = ''
      mkdir -p "$NIX_BUILD_TOP/toolchain"
      for t in gcc g++ ar strip ld nm ranlib; do
        ln -sf "$(command -v $t)" "$NIX_BUILD_TOP/toolchain/aarch64-linux-gnu-$t"
      done
      export PATH="$NIX_BUILD_TOP/toolchain:$PATH"
    '';

    buildPhase =
      builtins.replaceStrings
        [ "jnigenBuildLinux_x86_64" "libs/linux64/" ]
        [ "jnigenBuildLinux_Arm_64" "libs/linuxarm64/" ]
        old.buildPhase;

    meta = old.meta // {
      broken = false;
    };
  })
