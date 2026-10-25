{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "snd-hda-macbookpro";
  version = "0-unstable-2026-09-06-${kernel.version}";

  src = fetchFromGitHub {
    owner = "davidjo";
    repo = "snd_hda_macbookpro";
    rev = "89b22ff90b86468b186706861dd18663562defa7";
    hash = "sha256-5iDybAlRG5HldUA24L9+rSlgEiUPZg50K8IYC+Lie4U=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  # install.cirrus.driver.sh (>= 6.17) minus the download: patch the running kernel's own sound/hda
  postPatch = ''
    mkdir build
    tar -xf ${kernel.src} -C build --strip-components=2 --wildcards '*/sound/hda'
    cp makefiles/Makefile build/hda/Makefile
    cp makefiles/Makefile_common build/hda/common/Makefile
    cp makefiles/Makefile_codecs build/hda/codecs/Makefile
    cp makefiles/Makefile_cirrus build/hda/codecs/cirrus/Makefile
    cp patch_cirrus/{cirrus_apple.h,patch_cirrus_*.h} build/hda/codecs/cirrus/
    patch -d build/hda -p1 < patch_cs8409.c.diff
    patch -d build/hda -p1 < patch_cs8409.h.diff
  '';

  makeFlags = kernelModuleMakeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)/build/hda"
  ];
  preBuild = ''
    makeFlagsArray+=("CFLAGS_MODULE=-DAPPLE_PINSENSE_FIXUP -DAPPLE_CODECS -DCONFIG_SND_HDA_RECONFIG=1 -Wno-unused-variable -Wno-unused-function")
  '';
  buildFlags = [ "modules" ];

  # updates/ wins over the in-tree module in depmod's default search order
  installPhase = ''
    install -Dm444 build/hda/codecs/cirrus/snd-hda-codec-cs8409.ko \
      $out/lib/modules/${kernel.modDirVersion}/updates/snd-hda-codec-cs8409.ko
  '';

  meta = {
    description = "CS8409 HDA codec driver with Apple (MacBookPro14,x and later) support";
    homepage = "https://github.com/davidjo/snd_hda_macbookpro";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}
