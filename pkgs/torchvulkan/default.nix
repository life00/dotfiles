{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  cmake,
  ninja,
  shader-slang,
  vulkan-headers,
  vulkan-loader,
}:
pyFinal: pyPrev: {
  torchvulkan = pyFinal.buildPythonPackage rec {
    pname = "torchvulkan";
    version = "0.2.1";
    pyproject = true;

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/source/t/torchvulkan/torchvulkan-${version}.tar.gz";
      hash = "sha256-KDJSqVMutNgLvss0ZBUll8pDNNLS6iZ5Gm/xjUbDaIk=";
    };

    # Upstream pins the build-system torch to 2.13; the env provides 2.14.1.
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace-fail 'torch==2.13.0' 'torch>=2.10.0'
    '';

    build-system = [
      cmake
      ninja
      pyFinal.scikit-build-core
      pyFinal.setuptools-scm
    ];

    nativeBuildInputs = [
      autoPatchelfHook
      shader-slang
    ];

    buildInputs = [
      pyFinal.pybind11
      pyFinal.torch
      vulkan-headers
      vulkan-loader
      (lib.getLib stdenv.cc.cc)
    ];

    dependencies = [ pyFinal.torch ];

    env = {
      TORCH_INSTALL_PREFIX = "${pyFinal.torch.dev}";
      SETUPTOOLS_SCM_PRETEND_VERSION_FOR_TORCHVULKAN = version;
      CMAKE_ARGS = toString [
        (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${pyFinal.torch.dev}")
        (lib.cmakeFeature "Python3_EXECUTABLE" "${pyFinal.python.interpreter}")
        (lib.cmakeFeature "TORCH_PYTHON_LIBRARY" "${pyFinal.torch.lib}/lib/libtorch_python.so")
        (lib.cmakeFeature "SLANGC_EXE" "${lib.getExe shader-slang}")
        (lib.cmakeFeature "Vulkan_INCLUDE_DIR" "${vulkan-headers}/include")
        (lib.cmakeFeature "Vulkan_LIBRARY" "${lib.getLib vulkan-loader}/lib/libvulkan.so")
        (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-I${pyFinal.pybind11}/include")
      ];
    };

    # volk dlopens libvulkan.so.1; the loader is not a DT_NEEDED entry.
    appendRunpaths = [ "${lib.getLib vulkan-loader}/lib" ];

    dontUseCmakeConfigure = true;
    pythonImportsCheck = [ "torchvulkan" ];

    meta = {
      description = "Vulkan backend for PyTorch";
      homepage = "https://github.com/zainsharief/torchvulkan";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  };
}
