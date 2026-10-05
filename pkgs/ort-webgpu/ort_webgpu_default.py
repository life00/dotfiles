"""Make ONNX Runtime prefer the GPU (WebGPU EP -> Vulkan) by default. Opt out: ORT_WEBGPU=0.

Loaded from a .pth file; does nothing until onnxruntime / docling is actually imported.
"""

import importlib.abc
import logging
import os
import sys

_log = logging.getLogger(__name__)


def _patch_ort(ort):
    import onnxruntime_ep_webgpu as ep

    Orig = ort.InferenceSession
    state = {}

    def gpu_available():
        if "ok" not in state:
            try:
                ort.register_execution_provider_library(
                    ep.get_ep_name(), ep.get_library_path()
                )
                state["ok"] = any(
                    d.ep_name == ep.get_ep_name() for d in ort.get_ep_devices()
                )
            except Exception:
                _log.warning("ort_webgpu_default: WebGPU EP unavailable", exc_info=True)
                state["ok"] = False
        return state["ok"]

    class InferenceSession(Orig):
        def __init__(
            self, path_or_bytes, sess_options=None, providers=None, *args, **kwargs
        ):
            # only sessions that didn't ask for a specific accelerator
            if providers in (None, [], ["CPUExecutionProvider"]) and gpu_available():
                gpu_options = sess_options or ort.SessionOptions()
                gpu_options.set_provider_selection_policy(
                    ort.OrtExecutionProviderDevicePolicy.PREFER_GPU
                )
                try:
                    return super().__init__(
                        path_or_bytes, gpu_options, None, *args, **kwargs
                    )
                except Exception:
                    _log.warning(
                        "ort_webgpu_default: GPU session failed, using CPU",
                        exc_info=True,
                    )
            super().__init__(path_or_bytes, sess_options, providers, *args, **kwargs)

    ort.InferenceSession = InferenceSession


def _patch_docling(pipeline_options):
    from docling.datamodel.object_detection_engine_options import (
        OnnxRuntimeObjectDetectionEngineOptions,
    )

    cls = pipeline_options.LayoutObjectDetectionOptions
    cls.model_fields[
        "engine_options"
    ].default_factory = OnnxRuntimeObjectDetectionEngineOptions
    cls.model_rebuild(force=True)


_PATCHES = {
    "onnxruntime": _patch_ort,
    "docling.datamodel.pipeline_options": _patch_docling,
}


class _Hook(importlib.abc.MetaPathFinder):
    def find_spec(self, name, path, target=None):
        patch = _PATCHES.get(name)
        if patch is None:
            return None
        for finder in sys.meta_path:
            if finder is not self and (
                spec := getattr(finder, "find_spec", lambda *_: None)(
                    name, path, target
                )
            ):
                break
        else:
            return None
        exec_module = spec.loader.exec_module

        def exec_and_patch(module):
            exec_module(module)
            try:
                patch(module)
            except Exception:
                _log.warning(
                    "ort_webgpu_default: patching %s failed", name, exc_info=True
                )

        spec.loader.exec_module = exec_and_patch
        return spec


if os.environ.get("ORT_WEBGPU", "1") != "0":
    sys.meta_path.insert(0, _Hook())
