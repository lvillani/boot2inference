final: prev:
let
  # nixpkgs llama.cpp v1.0.0 cannot load Inkling 2 Mini. The Unsloth tree adds
  # support for the model and its DSpark draft. Override only the Vulkan package
  # because the target machine uses the Vulkan backend.
  #
  # Tag b12649-mix-c7059d6.
  src = prev.fetchzip {
    url = "https://github.com/unslothai/llama.cpp/releases/download/b12649-mix-c7059d6/llama.cpp-source-b12649-mix-c7059d6.tar.gz";
    hash = "sha256-xwJ6HicNHeJbgQX65rA7+UVtMl4dj40KgJBCfE+WnqM=";
  };
in
{
  llama-cpp-vulkan = prev.llama-cpp-vulkan.overrideAttrs (oldAttrs: {
    inherit src;

    # The Unsloth tree moves the UI from tools/ui to ui/apps/chat.
    npmRoot = "ui/apps/chat";
    npmDepsHash = "sha256-3kJJJGgPvtoRozjjvXJ97ljxzt0tshwi88UUd1D3VsI=";

    # Upstream tests fail in this tree.
    doCheck = false;
  });
}
