{ pkgs, ... }:

let
  #
  # Gemma 4 12B
  #

  gemma12ModelName = "gemma-4-12B-it-qat-UD-Q4_K_XL";

  gemma12Weights = pkgs.fetchurl {
    name = "${gemma12ModelName}.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/${gemma12ModelName}.gguf";
    hash = "sha256-kP1E4p4NfP/rD9ANxzz9q57QsOlTBuz3gh6mNMlAw3A=";
  };

  gemma12Mmproj = pkgs.fetchurl {
    name = "mmproj-F16.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/mmproj-F16.gguf";
    hash = "sha256-7MTpMSjag2O32/IZPquYzxFCNT9SzqoMlcCHKZeqrdM=";
  };

  gemma12Mtp = pkgs.fetchurl {
    name = "mtp-gemma-4-12B-it.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/mtp-gemma-4-12B-it.gguf";
    hash = "sha256-/LNd6kLHEzPbkEzuEbqsUlye+HKBjuN1P2yxVvPG9PY=";
  };

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
  # Qwen
  #

  qwenModelName = "Qwen3.8-27B-UD-Q2_K_XL";
  qwenTextModelName = "${qwenModelName}-text";

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
    mkdir -p "$out/${gemma12ModelName}"
    ln -s ${gemma12Weights} "$out/${gemma12ModelName}/${gemma12ModelName}.gguf"
    ln -s ${gemma12Mmproj} "$out/${gemma12ModelName}/mmproj-F16.gguf"
    ln -s ${gemma12Mtp} "$out/${gemma12ModelName}/mtp-gemma-4-12B-it.gguf"

    mkdir -p "$out/${gemma26ModelName}"
    ln -s ${gemma26Weights} "$out/${gemma26ModelName}/${gemma26ModelName}.gguf"
    ln -s ${gemma26Mmproj} "$out/${gemma26ModelName}/mmproj-F16.gguf"
    ln -s ${gemma26Mtp} "$out/${gemma26ModelName}/mtp-gemma-4-26B-A4B-it.gguf"

    mkdir -p "$out/${qwenModelName}"
    ln -s ${qwenWeights} "$out/${qwenModelName}/${qwenModelName}.gguf"
    ln -s ${qwenMmproj} "$out/${qwenModelName}/mmproj-F16.gguf"
  '';

  modelsIni = pkgs.writeText "models.ini" ''
    version = 1

    # The model is small enough to not need a quantized KV cache. The 8 full-attention
    # layers (1 KV head, 512 dim, K and V shared) need 16 KiB of KV cache per token at
    # f16, so the full 256K context plus the 1024-token sliding windows of the 40 local
    # layers cost about 4.3 GiB. Together with 6.7 GiB of weights, mmproj, and MTP draft
    # this uses about 12.3 GiB and leaves room to spare, so keep the KV cache at
    # lossless f16 for long-context recall.
    [${gemma12ModelName}]
    model = ${modelFiles}/${gemma12ModelName}/${gemma12ModelName}.gguf
    mmproj = ${modelFiles}/${gemma12ModelName}/mmproj-F16.gguf
    model-draft = ${modelFiles}/${gemma12ModelName}/mtp-gemma-4-12B-it.gguf
    cache-type-k = f16
    cache-type-v = f16
    ctx-size = 262144
    flash-attn = true
    jinja = true
    min-p = 0
    n-gpu-layers = all
    presence-penalty = 0
    repeat-penalty = 1
    spec-draft-n-max = 4
    spec-type = draft-mtp
    temp = 1.0
    top-k = 64
    top-p = 0.95

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

    [${qwenTextModelName}]
    model = ${modelFiles}/${qwenModelName}/${qwenModelName}.gguf
    cache-type-k = q8_0
    cache-type-v = q4_0
    ctx-size = 131072
    flash-attn = true
    jinja = true
    min-p = 0
    n-gpu-layers = all
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
    name = gemma12ModelName;
    path = "${modelFiles}/${gemma12ModelName}";
  }
  {
    name = gemma26ModelName;
    path = "${modelFiles}/${gemma26ModelName}";
  }
  {
    name = qwenModelName;
    path = "${modelFiles}/${qwenModelName}";
  }
]
