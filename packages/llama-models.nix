{ pkgs, ... }:

let
  #
  # Gemma
  #

  gemmaModelName = "gemma-4-12B-it-qat-UD-Q4_K_XL";

  gemmaWeights = pkgs.fetchurl {
    name = "${gemmaModelName}.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/${gemmaModelName}.gguf";
    hash = "sha256-kP1E4p4NfP/rD9ANxzz9q57QsOlTBuz3gh6mNMlAw3A=";
  };

  gemmaMmproj = pkgs.fetchurl {
    name = "mmproj-F16.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/mmproj-F16.gguf";
    hash = "sha256-7MTpMSjag2O32/IZPquYzxFCNT9SzqoMlcCHKZeqrdM=";
  };

  gemmaMtp = pkgs.fetchurl {
    name = "mtp-gemma-4-12B-it.gguf";
    url = "https://huggingface.co/unsloth/gemma-4-12B-it-qat-GGUF/resolve/980b060c40a8539ac159e0501a3e0f66a6365af3/mtp-gemma-4-12B-it.gguf";
    hash = "sha256-/LNd6kLHEzPbkEzuEbqsUlye+HKBjuN1P2yxVvPG9PY=";
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
    mkdir -p "$out/${gemmaModelName}"
    ln -s ${gemmaWeights} "$out/${gemmaModelName}/${gemmaModelName}.gguf"
    ln -s ${gemmaMmproj} "$out/${gemmaModelName}/mmproj-F16.gguf"
    ln -s ${gemmaMtp} "$out/${gemmaModelName}/mtp-gemma-4-12B-it.gguf"

    mkdir -p "$out/${qwenModelName}"
    ln -s ${qwenWeights} "$out/${qwenModelName}/${qwenModelName}.gguf"
    ln -s ${qwenMmproj} "$out/${qwenModelName}/mmproj-F16.gguf"
  '';

  modelsIni = pkgs.writeText "models.ini" ''
    version = 1

    [${gemmaModelName}]
    model = ${modelFiles}/${gemmaModelName}/${gemmaModelName}.gguf
    mmproj = ${modelFiles}/${gemmaModelName}/mmproj-F16.gguf
    model-draft = ${modelFiles}/${gemmaModelName}/mtp-gemma-4-12B-it.gguf
    cache-type-k = q8_0
    cache-type-v = q8_0
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

    [${qwenModelName}]
    model = ${modelFiles}/${qwenModelName}/${qwenModelName}.gguf
    mmproj = ${modelFiles}/${qwenModelName}/mmproj-F16.gguf
    cache-type-k = q8_0
    cache-type-v = q4_0
    ctx-size = 98304
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
    name = gemmaModelName;
    path = "${modelFiles}/${gemmaModelName}";
  }
  {
    name = qwenModelName;
    path = "${modelFiles}/${qwenModelName}";
  }
]
