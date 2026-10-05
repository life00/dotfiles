# Python overlay: ONNX Runtime (and docling layout) prefer the Asahi GPU via the WebGPU EP. Opt out: ORT_WEBGPU=0.
{
  lib,
  fetchurl,
  autoPatchelfHook,
  vulkan-loader,
}:
pyFinal: pyPrev: {
  # FIXME: drop once ORT discovers non-PCI DRM GPUs (cf. microsoft/onnxruntime#32544); costs a local ORT compile
  onnxruntime = pyPrev.onnxruntime.override (old: {
    onnxruntime = old.onnxruntime.overrideAttrs (a: {
      patches = (a.patches or [ ]) ++ [ ./asahi-gpu-discovery.patch ];
    });
  });

  onnxruntime-ep-webgpu = pyFinal.buildPythonPackage rec {
    pname = "onnxruntime-ep-webgpu";
    version = "0.4.0";
    format = "wheel";
    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/4e/ca/00c70322c19913c81a6bb2239aca83781b97a818b55c2ec3d25cec72dc4c/onnxruntime_ep_webgpu-${version}-py3-none-manylinux_2_28_aarch64.whl";
      hash = "sha256-F/Zg21OxpQnGPnIaxnhKLaocTpGpaFI+6ZhlBe5bClU=";
    };
    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [ (lib.getLib pyFinal.python.stdenv.cc.cc) ];
    appendRunpaths = [ "${lib.getLib vulkan-loader}/lib" ]; # Dawn dlopens libvulkan.so.1
    dependencies = [ pyFinal.onnxruntime ];
    postInstall = ''
      cp ${./ort_webgpu_default.py} $out/${pyFinal.python.sitePackages}/ort_webgpu_default.py
      echo "import ort_webgpu_default" > $out/${pyFinal.python.sitePackages}/ort_webgpu_default.pth
    '';
    pythonImportsCheck = [ "onnxruntime_ep_webgpu" ];
  };
}
