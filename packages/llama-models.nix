{ pkgs, ... }:

let
  #
  # Gemma 4 26B A4B
  #

  gemma26ModelName = "gemma-4-26B-A4B-it-qat-UD-Q4_K_XL";

  gemma26Weights = pkgs.fetchurl {
    name = "${gemma26ModelName}.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF/resolve/7b92b5b28818151e8669af2e45e88d6086f490dd/${gemma26ModelName}.gguf";
    hash = "sha256-p8W8cV9f+OmaPokBzn0rQrQCxmm/JPfFJQdHYz0PWJE=";
  };

  gemma26Mmproj = pkgs.fetchurl {
    name = "mmproj-F16.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF/resolve/7b92b5b28818151e8669af2e45e88d6086f490dd/mmproj-F16.gguf";
    hash = "sha256-0A8hGn1Pf7Gb2bddjpNC7M/7WSCwj9lWIWdWD9/MXdE=";
  };

  gemma26Mtp = pkgs.fetchurl {
    name = "mtp-gemma-4-26B-A4B-it.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-26B-A4B-it-qat-GGUF/resolve/7b92b5b28818151e8669af2e45e88d6086f490dd/mtp-gemma-4-26B-A4B-it.gguf";
    hash = "sha256-cnLZdZXw1MdL17YjSSt9var9i3xy8ymoJwuk7KaPdoo=";
  };

  #
  # Inkling 2 Mini
  #

  inklingModelName = "Inkling-2-Mini-UD-Q3_K_XL";

  inklingWeights = pkgs.fetchurl {
    name = "${inklingModelName}.gguf";
    url = "https://huggingface.co/unsloth/Inkling-2-Mini-GGUF/resolve/8078d149286eec7193795413b9e0643da6d11fa1/${inklingModelName}.gguf";
    hash = "sha256-4tA+jJKsIc/w4zCblfQN/SfRglGE8NK8Cdskl5cnNjk=";
  };

  inklingMmproj = pkgs.fetchurl {
    name = "mmproj-F16.gguf";
    url = "https://huggingface.co/unsloth/Inkling-2-Mini-GGUF/resolve/8078d149286eec7193795413b9e0643da6d11fa1/mmproj-F16.gguf";
    hash = "sha256-O/91/+stbgNxunvULjDSan2YrqaB+kSwO1ogiRz6LF8=";
  };

  inklingDspark = pkgs.fetchurl {
    name = "dspark-Inkling-2-Mini-Q8_0.gguf";
    url = "https://huggingface.co/unsloth/Inkling-2-Mini-GGUF/resolve/8078d149286eec7193795413b9e0643da6d11fa1/dspark-Inkling-2-Mini-Q8_0.gguf";
    hash = "sha256-PaAM98MbvlZis8DTc+z3gtdNMu9DmQrMFYzmDCrdcuA=";
  };

  #
  # Muse Glimmer 30B
  #

  museModelName = "Muse-Glimmer-30B-UD-Q3_K_XL";

  museWeights = pkgs.fetchurl {
    name = "${museModelName}.gguf";
    url = "https://huggingface.co/unsloth/Muse-Glimmer-30B-GGUF/resolve/faa5b025c584459c13febfa5c59883516710ae39/${museModelName}.gguf";
    hash = "sha256-gg0Y4AxZN2Mx66Yt1xamvNyqMFwjFvXaOi+rNsfDfhU=";
  };

  museMmproj = pkgs.fetchurl {
    name = "mmproj-Muse-Glimmer-30B-Q8_0.gguf";
    url = "https://huggingface.co/unsloth/Muse-Glimmer-30B-GGUF/resolve/faa5b025c584459c13febfa5c59883516710ae39/mmproj-Muse-Glimmer-30B-Q8_0.gguf";
    hash = "sha256-Af9zyVEI4XVKTBRRdsbTukQziUIoXLh9ysf08ZMZLqI=";
  };

  #
  # Qwen
  #

  qwenModelName = "Qwen3.8-27B-UD-Q2_K_XL";

  qwenWeights = pkgs.fetchurl {
    name = "${qwenModelName}.gguf";
    url = "https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/resolve/4af51b3542f775b0a8e4b310bfb3f17e01c306c9/${qwenModelName}.gguf";
    hash = "sha256-GPEYfzjnmUsFwIy0XGdLkLfxdSNofIOkYU/kk/fqc50=";
  };

  qwenMmproj = pkgs.fetchurl {
    name = "mmproj-F16.gguf";
    url = "https://huggingface.co/unsloth/Qwen3.8-27B-GGUF/resolve/4af51b3542f775b0a8e4b310bfb3f17e01c306c9/mmproj-F16.gguf";
    hash = "sha256-y7hBqe4GNrLsFy9buN8uqN/rAekP58YSZYHWYqC05D4=";
  };

  #
  # Models
  #

  modelFiles = pkgs.runCommand "llama-models-files" { } ''
    mkdir -p "$out/${gemma26ModelName}"
    ln -s ${gemma26Weights} "$out/${gemma26ModelName}/${gemma26ModelName}.gguf"
    ln -s ${gemma26Mmproj} "$out/${gemma26ModelName}/mmproj-F16.gguf"
    ln -s ${gemma26Mtp} "$out/${gemma26ModelName}/mtp-gemma-4-26B-A4B-it.gguf"

    mkdir -p "$out/${inklingModelName}"
    ln -s ${inklingWeights} "$out/${inklingModelName}/${inklingModelName}.gguf"
    ln -s ${inklingMmproj} "$out/${inklingModelName}/mmproj-F16.gguf"
    ln -s ${inklingDspark} "$out/${inklingModelName}/dspark-Inkling-2-Mini-Q8_0.gguf"

    mkdir -p "$out/${museModelName}"
    ln -s ${museWeights} "$out/${museModelName}/${museModelName}.gguf"
    ln -s ${museMmproj} "$out/${museModelName}/mmproj-Muse-Glimmer-30B-Q8_0.gguf"

    mkdir -p "$out/${qwenModelName}"
    ln -s ${qwenWeights} "$out/${qwenModelName}/${qwenModelName}.gguf"
    ln -s ${qwenMmproj} "$out/${qwenModelName}/mmproj-F16.gguf"
  '';

  modelsIni = pkgs.writeText "models.ini" ''
    version = 1

    # 13.3 GiB of weights plus the 0.2 GiB MTP draft and 16 GiB of VRAM do not leave
    # room for the 1.1 GiB vision encoder on the GPU, so the mmproj stays on the CPU.
    # The 5 full-attention layers need 20 KiB of KV cache per token, so 128K context
    # needs about 1.4 GiB at q8_0. Keep the KV cache at q8_0 because q4_0 V hurts
    # long-context recall. n-cpu-moe moves the expert weights of 4 layers (~0.4 GiB
    # each) to RAM to make room for the KV cache and the MTP draft. Raise the number if
    # loading runs out of VRAM, lower it if token speed is too slow.
    [${gemma26ModelName}]
    model = ${modelFiles}/${gemma26ModelName}/${gemma26ModelName}.gguf
    mmproj = ${modelFiles}/${gemma26ModelName}/mmproj-F16.gguf
    model-draft = ${modelFiles}/${gemma26ModelName}/mtp-gemma-4-26B-A4B-it.gguf
    cache-type-k = q8_0
    cache-type-v = q8_0
    ctx-size = 131072
    flash-attn = true
    jinja = true
    min-p = 0
    n-cpu-moe = 4
    n-gpu-layers = all
    no-mmproj-offload = true
    presence-penalty = 0
    repeat-penalty = 1
    spec-draft-n-max = 4
    spec-type = draft-mtp
    temp = 1.0
    top-k = 64
    top-p = 0.95

    # 12.7 GiB of weights. The middle layers 6-17 run three times per token, so the 24
    # physical layers need 48 KV cache slots and 8 of them hold full attention. Those 8
    # need 2.1 GiB at 128K with q8_0 keys and values. The Unsloth banded path handles
    # q8_0 and q4_0 K/V on CUDA, but not on Vulkan. Vulkan still builds the dense
    # relative bias. The fork makes that bias F16 and caps it at 128 query rows, so the
    # chunk needs about 0.8 GiB. The 0.7 GiB that this frees lets one more prelude layer
    # stay on the GPU, so n-cpu-moe moves the expert weights of only the first 5 layers
    # to RAM. Those layers are the prelude, so they run once per token, and this frees
    # 2.1 GiB with little speed loss. Do not raise the number past 6: layer 6 and layer
    # 7 run three times. The 0.5 GiB DSpark drafter sits on the GPU, and the 0.6 GiB
    # vision encoder stays on the CPU. Unsloth measured the second draft token as the
    # fastest depth. The model card gives temp 1.0, top-p 1.0, top-k off and min-p 0.
    [${inklingModelName}]
    model = ${modelFiles}/${inklingModelName}/${inklingModelName}.gguf
    mmproj = ${modelFiles}/${inklingModelName}/mmproj-F16.gguf
    model-draft = ${modelFiles}/${inklingModelName}/dspark-Inkling-2-Mini-Q8_0.gguf
    cache-type-k = q8_0
    cache-type-v = q8_0
    ctx-size = 131072
    flash-attn = true
    jinja = true
    min-p = 0
    n-cpu-moe = 5
    n-gpu-layers = all
    no-mmproj-offload = true
    presence-penalty = 0
    repeat-penalty = 1
    spec-draft-n-max = 2
    spec-type = draft-dspark
    temp = 1.0
    top-k = 0
    top-p = 1.0

    # Dense 52-layer model, so every token passes through every layer. Only UD-Q3_K_XL
    # (12.4 GiB) fits in 16 GiB of VRAM together with the KV cache; UD-Q4_K_XL (14.8
    # GiB) would force layer offload to slow DDR4. 13 of 52 layers are full attention (2
    # KV heads, 128 dim), the other 39 use a 2048-token sliding window, so the whole
    # 131072-token context costs only 1.7 GiB at lossless f16. Together with about
    # 0.4 GiB of compute buffers this uses about 14.5 GiB and leaves room to spare, so
    # keep the KV cache at f16 for long-context recall. The 1.9 GiB Q8_0 vision encoder
    # does not fit as well, so it stays on the CPU, as with Gemma 26B A4B. Meta's default
    # sampler settings are temp 1.0, top-p 0.95, top-k 64.
    [${museModelName}]
    model = ${modelFiles}/${museModelName}/${museModelName}.gguf
    mmproj = ${modelFiles}/${museModelName}/mmproj-Muse-Glimmer-30B-Q8_0.gguf
    cache-type-k = f16
    cache-type-v = f16
    ctx-size = 131072
    flash-attn = true
    jinja = true
    min-p = 0
    n-gpu-layers = all
    no-mmproj-offload = true
    presence-penalty = 0
    repeat-penalty = 1
    temp = 1.0
    top-k = 64
    top-p = 0.95

    # 16 of the 64 layers are full attention (4 KV heads, 256 dim); the rest are linear
    # attention with a constant-size state. The full-attention layers need 64 KiB of KV
    # cache per token at f16, so 128K context needs about 3.4 GiB with q8_0 keys and
    # q4_0 values. Together with 9.3 GiB of weights this almost fills 16 GiB of VRAM, so
    # the 0.9 GiB vision encoder stays on the CPU, as with Gemma 26B A4B. The MTP draft
    # head is inside the main GGUF (blk.64), so no model-draft file is necessary.
    [${qwenModelName}]
    model = ${modelFiles}/${qwenModelName}/${qwenModelName}.gguf
    mmproj = ${modelFiles}/${qwenModelName}/mmproj-F16.gguf
    cache-type-k = q8_0
    cache-type-v = q4_0
    ctx-size = 131072
    flash-attn = true
    jinja = true
    min-p = 0
    n-gpu-layers = all
    no-mmproj-offload = true
    presence-penalty = 0
    repeat-penalty = 1
    spec-draft-n-max = 2
    spec-type = draft-mtp
    temp = 1
    top-k = 20
    top-p = 0.95
  '';
in
pkgs.linkFarm "llama-models" [
  {
    name = "models.ini";
    path = modelsIni;
  }
  {
    name = gemma26ModelName;
    path = "${modelFiles}/${gemma26ModelName}";
  }
  {
    name = inklingModelName;
    path = "${modelFiles}/${inklingModelName}";
  }
  {
    name = museModelName;
    path = "${modelFiles}/${museModelName}";
  }
  {
    name = qwenModelName;
    path = "${modelFiles}/${qwenModelName}";
  }
]
