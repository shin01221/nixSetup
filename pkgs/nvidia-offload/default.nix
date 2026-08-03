{
  pkgs,
  ...
}:
pkgs.writeShellScriptBin "nvidia-offload" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_SYNC_TO_VBLANK=0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  for icd in \
    /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json \
    /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.x86_64.json \
    /run/opengl-driver/lib/vulkan/icd.d/nvidia_icd.json \
    /run/opengl-driver/lib/vulkan/icd.d/nvidia_icd.x86_64.json
  do
    if [ -f "$icd" ]; then
      export VK_ICD_FILENAMES="$icd"
      break
    fi
  done
  exec "$@"
''
